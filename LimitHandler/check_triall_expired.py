#!/usr/bin/env python3

import os
import subprocess
from datetime import datetime

db_list = {
    "vmess": "/etc/lunatic/vmess/.vmess.db",
    "vless": "/etc/lunatic/vless/.vless.db",
    "trojan": "/etc/lunatic/trojan/.trojan.db",
    "ssh": "/etc/lunatic/ssh/.ssh.db"
}

kill_script = "/usr/bin/kill_triall.py"


def ssh_expired(user):
    try:
        out = subprocess.check_output(["chage", "-l", user]).decode()

        for line in out.split("\n"):
            if "Account expires" in line:

                if "never" in line.lower():
                    return False

                exp = line.split(":")[1].strip()
                exp_date = datetime.strptime(exp, "%b %d, %Y")

                # PERBAIKAN: bandingkan hanya tanggalnya
                if exp_date.date() < datetime.now().date():
                    return True
                else:
                    return False

    except:
        return False


for mode, db_path in db_list.items():

    if not os.path.exists(db_path):
        continue

    with open(db_path) as f:

        for line in f:

            line = line.strip()

            if not line:
                continue

            parts = line.split()

            try:

                if mode == "ssh":

                    if not line.startswith("#ssh#"):
                        continue

                    if len(parts) < 2:
                        continue

                    username = parts[1]

                    if username.startswith("/"):
                        continue

                    if ssh_expired(username):
                        subprocess.run(["python3", kill_script, "ssh_dell", username])

                else:

                    if not line.startswith("###"):
                        continue

                    if len(parts) < 3:
                        continue

                    username = parts[1]
                    exp = parts[2]

                    if datetime.strptime(exp, "%Y-%m-%d") <= datetime.now():
                        subprocess.run(["python3", kill_script, f"{mode}_dell", username])

            except:
                continue