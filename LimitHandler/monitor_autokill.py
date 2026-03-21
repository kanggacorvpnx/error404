#!/usr/bin/env python3
import os
import subprocess
from datetime import datetime
import requests
import time

# Path konfigurasi
SERVICES = {
    "trojan": "/etc/lunatic/trojan",
    "vmess": "/etc/lunatic/vmess",
    "vless": "/etc/lunatic/vless",
    "ssh": "/etc/lunatic/ssh"
}
XRAY_ACCESS_LOG = "/var/log/xray/access.log"
TELEGRAM_KEY_PATH = "/etc/lunatic/bot/notif/key"
TELEGRAM_ID_PATH = "/etc/lunatic/bot/notif/id"
CHECK_INTERVAL = 10  # detik

def load_telegram_credentials():
    try:
        with open(TELEGRAM_KEY_PATH, 'r') as f:
            key = f.read().strip()
        with open(TELEGRAM_ID_PATH, 'r') as f:
            chat_id = f.read().strip()
        return key, chat_id
    except:
        return None, None

def send_telegram_notification(user, service):
    key, chat_id = load_telegram_credentials()
    if not key or not chat_id:
        return
    text = (
        f"<code>🚨 AUTOKILL DETECTED</code>\n"
        f"<code>Service : {service}</code>\n"
        f"<code>User    : {user}</code>\n"
        f"<code>Reason  : Limit IP Terlampaui</code>\n"
        f"<code>Time    : {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</code>"
    )
    try:
        requests.post(
            f"https://api.telegram.org/bot{key}/sendMessage",
            data={"chat_id": chat_id, "text": text, "parse_mode": "HTML"},
            timeout=5
        )
    except:
        pass

def get_active_ips(user, service):
    try:
        if service == "ssh":
            result = subprocess.run(["ps", "-ef"], stdout=subprocess.PIPE, text=True)
            return len(set([line.split()[-1] for line in result.stdout.splitlines() if user in line]))
        else:
            if not os.path.exists(XRAY_ACCESS_LOG):
                return 0
            with open(XRAY_ACCESS_LOG, 'r') as log_file:
                lines = log_file.readlines()
            return len(set([line.split()[2] for line in lines if user in line]))
    except:
        return 0

def remove_user(user, service):
    base_path = SERVICES[service]
    config_path = "/etc/xray/config.json"
    db_path = os.path.join(base_path, f".{service}.db")

    # Hapus dari config.json
    if os.path.exists(config_path):
        with open(config_path, 'r+') as f:
            content = f.read()
            content = content.replace(user, "")
            f.seek(0)
            f.write(content)
            f.truncate()

    for sub in ["ip", "usage", "detail"]:
        path = os.path.join(base_path, sub, user if sub != "detail" else f"{user}.txt")
        if os.path.exists(path):
            os.remove(path)

    if os.path.exists(db_path):
        with open(db_path, "r+") as db_file:
            lines = db_file.readlines()
            db_file.seek(0)
            db_file.writelines([line for line in lines if user not in line])
            db_file.truncate()

    if service == "ssh":
        subprocess.run(["userdel", "-f", user])

    subprocess.run(["systemctl", "restart", "xray"], stdout=subprocess.DEVNULL)
    if service == "ssh":
        subprocess.run(["systemctl", "restart", "ssh"], stdout=subprocess.DEVNULL)

def check_and_autokill():
    for service, base_path in SERVICES.items():
        ip_path = os.path.join(base_path, "ip")
        if not os.path.isdir(ip_path):
            continue
        for user in os.listdir(ip_path):
            try:
                with open(os.path.join(ip_path, user), 'r') as f:
                    limit = int(f.read().strip())
                if limit == 0:
                    continue
                active_ip_count = get_active_ips(user, service)
                if active_ip_count > limit:
                    send_telegram_notification(user, service)
                    remove_user(user, service)
            except Exception:
                continue

# Jalankan terus-menerus
if __name__ == "__main__":
    while True:
        check_and_autokill()
        time.sleep(CHECK_INTERVAL)
