#!/usr/bin/env python3
import os
import subprocess
import time
import requests
from datetime import datetime
from pathlib import Path

# ================= CONFIG =================
SERVICES = {
    "trojan": "/etc/lunatic/trojan",
    "vmess": "/etc/lunatic/vmess",
    "vless": "/etc/lunatic/vless",
    "ssh": "/etc/lunatic/ssh"
}

XRAY_CONFIG = "/etc/xray/config.json"
XRAY_ACCESS_LOG = "/var/log/xray/access.log"

LOCK_DIR = "/etc/lunatic/lock"
BACKUP_DIR = "/etc/lunatic/backup"

LOCK_DURATION = 15 * 60
CHECK_INTERVAL = 10

# QUOTA
LIMIT_PATH = "/etc/limit"

# TELEGRAM
TELEGRAM_KEY_PATH = "/etc/lunatic/bot/notif/key"
TELEGRAM_ID_PATH = "/etc/lunatic/bot/notif/id"

os.makedirs(LOCK_DIR, exist_ok=True)
os.makedirs(BACKUP_DIR, exist_ok=True)

# ================= TELEGRAM =================
def load_telegram_credentials():
    try:
        return Path(TELEGRAM_KEY_PATH).read_text().strip(), Path(TELEGRAM_ID_PATH).read_text().strip()
    except:
        return None, None

def send_telegram(user, service, status):
    key, chat_id = load_telegram_credentials()
    if not key:
        return

    text = (
        f"<code>⚠️ AUTO {status}</code>\n"
        f"<code>User    : {user}</code>\n"
        f"<code>Service : {service}</code>\n"
        f"<code>Time    : {datetime.now()}</code>"
    )

    try:
        requests.post(
            f"https://api.telegram.org/bot{key}/sendMessage",
            data={"chat_id": chat_id, "text": text, "parse_mode": "HTML"},
            timeout=5
        )
    except:
        pass

# ================= XRAY =================
def reload_xray():
    subprocess.run(["systemctl", "restart", "xray"], stdout=subprocess.DEVNULL)

# ================= IP =================
def get_active_ips(user, service):
    try:
        if service == "ssh":
            result = subprocess.run(["who"], stdout=subprocess.PIPE, text=True)
            return len(set([line.split()[2] for line in result.stdout.splitlines() if user in line]))
        else:
            if not os.path.exists(XRAY_ACCESS_LOG):
                return 0

            with open(XRAY_ACCESS_LOG) as f:
                return len(set([
                    line.split()[2] for line in f.readlines() if user in line
                ]))
    except:
        return 0

# ================= QUOTA =================
def get_downlink(user):
    try:
        result = subprocess.check_output([
            "xray", "api", "stats", "--server=127.0.0.1:10000",
            f"-name=user>>>{user}>>>traffic>>>downlink"
        ]).decode()

        for line in result.splitlines():
            if '"value"' in line:
                return int(line.split(':')[1].strip().replace(',', ''))
    except:
        return 0

def update_usage(user, protocol):
    usage_file = f"{LIMIT_PATH}/{protocol}/{user}"
    Path(f"{LIMIT_PATH}/{protocol}").mkdir(parents=True, exist_ok=True)

    downlink = get_downlink(user)

    current = 0
    if Path(usage_file).exists():
        current = int(Path(usage_file).read_text().strip() or 0)

    Path(usage_file).write_text(str(current + downlink))

    subprocess.run([
        "xray", "api", "stats", "--server=127.0.0.1:10000",
        f"-name=user>>>{user}>>>traffic>>>downlink", "-reset"
    ], stdout=subprocess.DEVNULL)

    return current + downlink

def get_quota_limit(user, protocol):
    try:
        return int(Path(f"/etc/lunatic/{protocol}/usage/{user}").read_text().strip())
    except:
        return 0

# ================= USER =================
def user_exists(user):
    try:
        return user in Path(XRAY_CONFIG).read_text()
    except:
        return False

def backup_user(user):
    backup_file = f"{BACKUP_DIR}/{user}.txt"
    if os.path.exists(backup_file):
        return

    with open(XRAY_CONFIG) as f:
        lines = f.readlines()

    result = []
    for i in range(len(lines)):
        if user in lines[i]:
            result.append(lines[i])
            if i+1 < len(lines):
                result.append(lines[i+1])

    if result:
        Path(backup_file).write_text("".join(result))

def remove_user(user):
    with open(XRAY_CONFIG) as f:
        lines = f.readlines()

    new = [l for l in lines if user not in l]

    Path(XRAY_CONFIG).write_text("".join(new))
    return True

# ================= LOCK =================
def lock_user(user, service, reason):
    lock_file = f"{LOCK_DIR}/{user}.lock"
    if os.path.exists(lock_file):
        return

    unlock_time = int(time.time()) + LOCK_DURATION

    if service != "ssh":
        backup_user(user)
        remove_user(user)
        reload_xray()
    else:
        subprocess.run(["passwd", "-l", user])

    Path(lock_file).write_text(str(unlock_time))

    send_telegram(user, service, f"LOCKED ({reason})")
    print(f"[LOCK-{reason}] {user}")

# ================= UNLOCK =================
def unlock_user(user):
    lock_file = f"{LOCK_DIR}/{user}.lock"
    if not os.path.exists(lock_file):
        return

    subprocess.run(["passwd", "-u", user])
    os.remove(lock_file)

    send_telegram(user, "ALL", "UNLOCKED")
    print(f"[UNLOCK] {user}")

# ================= CHECK =================
def check_unlocks():
    now = int(time.time())

    for file in os.listdir(LOCK_DIR):
        user = file.replace(".lock", "")
        unlock_time = int(Path(f"{LOCK_DIR}/{file}").read_text())

        if now >= unlock_time:
            unlock_user(user)

def check_all():
    for service, base_path in SERVICES.items():
        ip_path = os.path.join(base_path, "ip")

        if not os.path.isdir(ip_path):
            continue

        for user in os.listdir(ip_path):
            try:
                if os.path.exists(f"{LOCK_DIR}/{user}.lock"):
                    continue

                # === IP CHECK ===
                ip_limit = int(Path(f"{ip_path}/{user}").read_text().strip())
                active = get_active_ips(user, service)

                if ip_limit > 0 and active > ip_limit:
                    lock_user(user, service, "IP")
                    continue

                # === QUOTA CHECK ===
                if service != "ssh":
                    used = update_usage(user, service)
                    limit = get_quota_limit(user, service)

                    if limit > 0 and used > limit:
                        lock_user(user, service, "QUOTA")

            except Exception as e:
                print("ERROR:", user, e)

# ================= LOOP =================
if __name__ == "__main__":
    while True:
        check_all()
        check_unlocks()
        time.sleep(CHECK_INTERVAL)