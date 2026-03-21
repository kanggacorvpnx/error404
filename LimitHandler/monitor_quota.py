#!/usr/bin/env python3
import os
import time
import requests
import subprocess
from pathlib import Path

# Konfigurasi Telegram
CHAT_ID_PATH = "/etc/lunatic/bot/notif/id"
BOT_KEY_PATH = "/etc/lunatic/bot/notif/key"

# Folder akun
PROTOCOLS = ["vless", "vmess", "trojan"]

# Log file
LOG_PATH = "/var/log/lunatic_quota_monitor.log"

# Notifikasi Telegram

def send_log(user, protocol, total2, total):
    try:
        chat_id = Path(CHAT_ID_PATH).read_text().strip()
        key = Path(BOT_KEY_PATH).read_text().strip()
        url = f"https://api.telegram.org/bot{key}/sendMessage"
        text = f"""
<code>────────────────────</code>
<b>⚠️ QUOTA HABIS XRAY {protocol.upper()} ⚠️</b>
<code>────────────────────</code>
<code>User    : </code><code>{user}</code>
<code>Limit   : </code><code>{total2}</code>
<code>Used    : </code><code>{total}</code>
<code>────────────────────</code>
"""
        requests.post(url, data={
            "chat_id": chat_id,
            "text": text,
            "parse_mode": "html",
            "disable_web_page_preview": "1"
        })
    except Exception as e:
        log(f"[TelegramError] {e}")


def convert_bytes(byte_val):
    byte_val = int(byte_val)
    if byte_val < 1024:
        return f"{byte_val}B"
    elif byte_val < 1048576:
        return f"{(byte_val + 1023)//1024}KB"
    elif byte_val < 1073741824:
        return f"{(byte_val + 1048575)//1048576}MB"
    else:
        return f"{(byte_val + 1073741823)//1073741824}GB"


def get_downlink(user):
    try:
        result = subprocess.check_output([
            "xray", "api", "stats", "--server=127.0.0.1:10000",
            f"-name=user>>>{user}>>>traffic>>>downlink"
        ]).decode()
        for line in result.splitlines():
            if '"value"' in line:
                return int(line.split(':')[1].strip().replace(',', ''))
    except Exception:
        return None


def get_active_devices(user):
    try:
        result = subprocess.check_output(["lsof", "-iTCP", "-sTCP:ESTABLISHED", "-nP"]).decode()
        return len([line for line in result.splitlines() if user in line])
    except Exception:
        return 0


def log(message):
    with open(LOG_PATH, "a") as logf:
        logf.write(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {message}\n")


def monitor():
    while True:
        time.sleep(5)
        for protocol in PROTOCOLS:
            usage_path = f"/etc/lunatic/{protocol}/usage"
            users = Path(usage_path).glob("*")
            for file in users:
                user = file.name
                limit_path = f"/etc/lunatic/{protocol}/usage/{user}"
                usage_file = f"/etc/limit/{protocol}/{user}"
                device_limit_path = f"/etc/lunatic/{protocol}/ip/{user}"

                # Ambil data penggunaan
                downlink = get_downlink(user)
                if downlink is None:
                    continue

                # Hitung devices aktif
                active_devices = get_active_devices(user)
                try:
                    max_devices = int(Path(device_limit_path).read_text().strip())
                except:
                    max_devices = 0

                # Tulis akumulasi
                Path(f"/etc/limit/{protocol}").mkdir(parents=True, exist_ok=True)
                if Path(usage_file).exists():
                    current = int(Path(usage_file).read_text().strip() or 0)
                    Path(usage_file).write_text(str(downlink + current))
                else:
                    Path(usage_file).write_text(str(downlink))

                # Reset statistik per user
                subprocess.run([
                    "xray", "api", "stats", "--server=127.0.0.1:10000",
                    f"-name=user>>>{user}>>>traffic>>>downlink", "-reset"
                ], stdout=subprocess.DEVNULL)

                # Bandingkan dan hapus jika melebihi
                try:
                    limit = int(Path(limit_path).read_text().strip())
                    used = int(Path(usage_file).read_text().strip())

                    if (limit > 0 and used > limit) or (max_devices > 0 and active_devices > max_devices):
                        reason = "QUOTA" if used > limit else "DEVICE"
                        send_log(user, protocol, convert_bytes(limit), convert_bytes(used))
                        log(f"{user} ({protocol}) removed due to {reason}-LIMIT")

                        # Hapus dari config.json dan DB
                        subprocess.run(["sed", "-i", f"/^#.*ACC# {user} /d", "/etc/xray/config.json"])
                        subprocess.run(["sed", "-i", f"/^### {user} /d", f"/etc/lunatic/{protocol}/.{protocol}.db"])

                        # Hapus file terkait
                        for f in [
                            f"/etc/limit/{protocol}/{user}",
                            f"/etc/limit/{protocol}/quota/{user}",
                            f"/etc/lunatic/{protocol}/usage/{user}",
                            f"/etc/lunatic/{protocol}/detail/{user}.txt",
                            f"/var/www/html/{protocol[:3]}-{user}.txt"
                        ]:
                            try:
                                os.remove(f)
                            except FileNotFoundError:
                                pass
                        subprocess.run(["systemctl", "restart", "xray"])
                except Exception as e:
                    log(f"[MonitorError] {user}: {e}")

if __name__ == "__main__":
    monitor()
    
