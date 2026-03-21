#!/usr/bin/env python3

import os
import sys
import subprocess
from datetime import datetime

XRAY_CONFIG = "/etc/xray/config.json"

SSH_DB = "/etc/lunatic/ssh/.ssh.db"
VMESS_DB = "/etc/lunatic/vmess/.vmess.db"
VLESS_DB = "/etc/lunatic/vless/.vless.db"
TROJAN_DB = "/etc/lunatic/trojan/.trojan.db"

LOG_FILE = "/var/log/trial_kill.log"


def restart_service(service):
    subprocess.run(["systemctl", "restart", service], stdout=subprocess.DEVNULL)


def remove_files(files):
    for f in files:
        if os.path.exists(f):
            os.remove(f)


def log(user, mode):
    with open(LOG_FILE, "a") as f:
        f.write(f"{datetime.now()} Deleted {user} from {mode}\n")


# ================= SSH DELETE =================

def delssh(user):

    print(f"Deleting SSH user: {user}")

    subprocess.run(["pkill", "-u", user], stdout=subprocess.DEVNULL)
    subprocess.run(["userdel", "-r", user], stdout=subprocess.DEVNULL)

    remove_files([
        f"/etc/lunatic/ssh/ip/{user}",
        f"/etc/lunatic/ssh/{user}",
        f"/etc/lunatic/ssh/detail/{user}.txt",
        f"/var/www/html/ssh-{user}.txt"
    ])

    # remove from DB
    subprocess.run(["sed", "-i", f"/^#ssh# {user} /d", SSH_DB])

    # remove broken entry
    subprocess.run(["sed", "-i", "/#ssh# \\/start/d", SSH_DB])

    for svc in ["ssh", "dropbear", "ws"]:
        restart_service(svc)

    log(user, "ssh")


# ================= VMESS =================

def delvmess(user):

    print(f"Deleting VMESS user: {user}")

    subprocess.run([
        "sed","-i",
        f"/^#vmeACC# {user}/,/^}},{{/d",
        XRAY_CONFIG
    ])

    subprocess.run([
        "sed","-i",
        f"/^### {user} /d",
        VMESS_DB
    ])

    remove_files([
        f"/etc/lunatic/vmess/usage/{user}",
        f"/etc/lunatic/vmess/ip/{user}",
        f"/etc/lunatic/vmess/{user}",
        f"/etc/lunatic/vmess/detail/{user}.txt",
        f"/var/www/html/vme-{user}.txt"
    ])

    restart_service("xray")

    log(user, "vmess")


# ================= VLESS =================

def delvless(user):

    print(f"Deleting VLESS user: {user}")

    subprocess.run([
        "sed","-i",
        f"/^#vleACC# {user}/,/^}},{{/d",
        XRAY_CONFIG
    ])

    subprocess.run([
        "sed","-i",
        f"/^### {user} /d",
        VLESS_DB
    ])

    remove_files([
        f"/etc/lunatic/vless/usage/{user}",
        f"/etc/lunatic/vless/ip/{user}",
        f"/etc/lunatic/vless/detail/{user}.txt",
        f"/var/www/html/vle-{user}.txt"
    ])

    restart_service("xray")

    log(user, "vless")


# ================= TROJAN =================

def deltrojan(user):

    print(f"Deleting TROJAN user: {user}")

    subprocess.run([
        "sed","-i",
        f"/^#troACC# {user}/,/^}},{{/d",
        XRAY_CONFIG
    ])

    subprocess.run([
        "sed","-i",
        f"/^### {user} /d",
        TROJAN_DB
    ])

    remove_files([
        f"/etc/lunatic/trojan/usage/{user}",
        f"/etc/lunatic/trojan/ip/{user}",
        f"/etc/lunatic/trojan/detail/{user}.txt",
        f"/var/www/html/tro-{user}.txt"
    ])

    restart_service("xray")

    log(user, "trojan")


# ================= MAIN =================

if __name__ == "__main__":

    if len(sys.argv) != 3:
        sys.exit(1)

    mode = sys.argv[1]
    user = sys.argv[2]

    if mode == "ssh_dell":
        delssh(user)

    elif mode == "vme_dell":
        delvmess(user)

    elif mode == "vle_dell":
        delvless(user)

    elif mode == "tro_dell":
        deltrojan(user)