#!/usr/bin/env python3

import os
import json
import subprocess
from datetime import datetime

XRAY_CONFIG = "/etc/xray/config.json"
TODAY = datetime.now().date()

SERVICES = ["xray", "nginx"]

ACCOUNTS = {
    "vmess": {
        "db": "/etc/lunatic/vmess/.vmess.db",
        "tag": "#vmeACC#",
        "ip": "/etc/lunatic/vmess/ip",
        "usage": "/etc/lunatic/vmess/usage",
        "detail": "/etc/lunatic/vmess/detail"
    },
    "vless": {
        "db": "/etc/lunatic/vless/.vless.db",
        "tag": "#vleACC#",
        "ip": "/etc/lunatic/vless/ip",
        "usage": "/etc/lunatic/vless/usage",
        "detail": "/etc/lunatic/vless/detail"
    },
    "trojan": {
        "db": "/etc/lunatic/trojan/.trojan.db",
        "tag": "#troACC#",
        "ip": "/etc/lunatic/trojan/ip",
        "usage": "/etc/lunatic/trojan/usage",
        "detail": "/etc/lunatic/trojan/detail"
    }
}

SSH_DB = "/etc/lunatic/ssh/.ssh.db"

def restart_services():
    for svc in SERVICES:
        subprocess.run(["systemctl", "restart", svc],
                       stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL)

def remove_file(path):
    if os.path.exists(path):
        os.remove(path)

def delete_xray_user(username, tag):
    with open(XRAY_CONFIG) as f:
        lines = f.readlines()

    new = []
    skip = False

    for line in lines:
        if tag in line and username in line:
            skip = True
            continue
        if skip and line.strip().startswith("},"):
            skip = False
            continue
        if not skip:
            new.append(line)

    with open(XRAY_CONFIG, "w") as f:
        f.writelines(new)

def process_xray_accounts(name, cfg):
    if not os.path.exists(cfg["db"]):
        return

    new_db = []

    with open(cfg["db"]) as f:
        for line in f:
            if not line.startswith("###"):
                continue

            user, exp = line.strip().split()[1:3]
            exp_date = datetime.strptime(exp, "%Y-%m-%d").date()

            if exp_date <= TODAY:
                delete_xray_user(user, cfg["tag"])
                remove_file(f"{cfg['ip']}/{user}")
                remove_file(f"{cfg['usage']}/{user}")
                remove_file(f"{cfg['detail']}/{user}.txt")
            else:
                new_db.append(line)

    with open(cfg["db"], "w") as f:
        f.writelines(new_db)

def process_ssh():
    if not os.path.exists(SSH_DB):
        return

    new_db = []

    with open(SSH_DB) as f:
        for line in f:
            if not line.startswith("#ssh#"):
                new_db.append(line)
                continue

            parts = line.strip().split()
            user = parts[1]
            exp_str = " ".join(parts[3:6])
            exp_date = datetime.strptime(exp_str, "%d %b, %Y").date()

            if exp_date <= TODAY:
                subprocess.run(["userdel", "-f", user],
                               stdout=subprocess.DEVNULL,
                               stderr=subprocess.DEVNULL)
                remove_file(f"/etc/lunatic/ssh/ip/{user}")
                remove_file(f"/etc/lunatic/ssh/detail/{user}.txt")
            else:
                new_db.append(line)

    with open(SSH_DB, "w") as f:
        f.writelines(new_db)

def main():
    for name, cfg in ACCOUNTS.items():
        process_xray_accounts(name, cfg)

    process_ssh()
    restart_services()

if __name__ == "__main__":
    main()
