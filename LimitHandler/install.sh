#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
set -e

echo "✅ Downloading monitor_quota.py..."
wget -O /usr/bin/monitor_quota.py https://raw.githubusercontent.com/kanggacorvpnx/error404/main/LimitHandler/monitor_quota.py

echo "✅ Downloading monitor_autokill.py..."
wget -O /usr/bin/monitor_autokill.py https://raw.githubusercontent.com/kanggacorvpnx/error404/main/LimitHandler/monitor_autokill.py

echo "✅ Downloading autodelete.py..."
wget -O /usr/bin/autodelete.py https://raw.githubusercontent.com/kanggacorvpnx/error404/main/LimitHandler/autodelete.py

echo "✅ Downloading kill_triall.py..."
wget -O /usr/bin/kill_triall.py https://raw.githubusercontent.com/kanggacorvpnx/error404/main/LimitHandler/kill_triall.py
wget -O /usr/bin/check_triall_expired.py https://raw.githubusercontent.com/kanggacorvpnx/error404/main/LimitHandler/check_triall_expired.py

echo "✅ Downloading Autolocked.py..."
wget -O /usr/bin/autolocked.py https://raw.githubusercontent.com/kanggacorvpnx/error404/main/LimitHandler/autolocked.py

echo "✅ Downloading shoot.sh..."
wget -O /usr/bin/shoot-dell.sh https://raw.githubusercontent.com/kanggacorvpnx/error404/main/LimitHandler/shoot-dell.sh

chmod +x /usr/bin/monitor_quota.py
chmod +x /usr/bin/monitor_autokill.py
chmod +x /usr/bin/autodelete.py
chmod +x /usr/bin/kill_triall.py
chmod +x /usr/bin/autolocked.py
chmod +x /usr/bin/check_triall_expired.py
chmod +x /usr/bin/shoot-dell.sh

touch /var/log/lunatic_quota_monitor.log
chmod 644 /var/log/lunatic_quota_monitor.log

############################################
# SERVICE MONITOR
############################################
cat > /etc/systemd/system/autolocked.service <<-EOF
[Unit]
Description=AutoLock XRAY (IP + QUOTA)
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /usr/bin/autolocked.py
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/monitor-quota.service <<-EOF
[Unit]
Description=Auto Monitor Xray Quota & Device
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/env python3 /usr/bin/monitor_quota.py
Restart=always
RestartSec=10
StandardOutput=append:/var/log/lunatic_quota_monitor.log
StandardError=append:/var/log/lunatic_quota_monitor.log

[Install]
WantedBy=multi-user.target
EOF

cat > /etc/systemd/system/monitor-autokill.service <<-EOF
[Unit]
Description=AutoKill IP Limit for XRAY/SSH Users
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /usr/bin/monitor_autokill.py
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

############################################
# ====== BAGIAN DIPERBAIKI: AUTODELETE ======
############################################

# SERVICE AUTODELETE (ONESHOOT)
cat > /etc/systemd/system/autodelete.service <<-EOF
[Unit]
Description=Auto Delete Expired Xray & SSH Accounts
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/python3 /usr/bin/autodelete.py
EOF

# TIMER AUTODELETE (INI YANG BENAR)
cat > /etc/systemd/system/autodelete.timer <<-EOF
[Unit]
Description=Daily Auto Delete Expired Accounts

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

cat > /etc/systemd/system/shoot-dell.service <<-EOF
[Unit]
Description=Trial Monitor Lunatic
After=network.target

[Service]
ExecStart=/usr/bin/shoot-dell.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF
############################################
# AKTIFKAN SEMUA SERVICE
############################################

echo "🚀 Mengaktifkan service..."
systemctl daemon-reload

# QUOTA MONITOR
systemctl enable monitor-quota
systemctl restart monitor-quota

# AUTOKILL
systemctl enable monitor-autokill
systemctl restart monitor-autokill

# AUTODELETE (FIXED)
systemctl enable autodelete.timer
systemctl start autodelete.timer

# AUTOLOCKED (FIXED)
systemctl enable autolocked
systemctl restart autolocked

# SHOOT DELL
systemctl enable shoot-dell
systemctl start shoot-dell

clear
echo "✅ Instalasi selesai!"
echo -e "\e[93;1m ======================================= \e[0m"
echo -e "\e[95;1m Auto Kill Triall    :\e[92;1m install succes \e[0m"
echo -e "\e[95;1m Autokill multilogin :\e[92;1m install succes \e[0m"
echo -e "\e[95;1m Auto Delete expire  :\e[92;1m install succes \e[0m"
echo -e "\e[95;1m Auto Limit quota    :\e[92;1m install succes \e[0m"
echo -e "\e[93;1m ======================================= \e[0m"
sleep 3