#!/bin/bash

apt update
apt install python3 -y
apt install python3-pip -y
apt install python3-requests -y

dirmeluna="/etc/whoiamluna"

mkdir -p $dirmeluna

repo="https://raw.githubusercontent.com/kanggacorvpnx/error404/main/"

wget -q -O $dirmeluna/ws.py "${repo}configure/ws.py"
chmod +x $dirmeluna/ws.py


# Installing Service
cat > /etc/systemd/system/ws.service << END
[Unit]
Description=Websocket
Documentation=https://google.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python3 -O $dirmeluna/ws.py 10015
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ws.service
systemctl start ws.service
systemctl restart ws.service

# Installing Service
cat > /etc/systemd/system/ws-ovpn.service << END
[Unit]
Description=OpenVPN
Documentation=https://google.com
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python3 -O $dirmeluna/ws.py 10012
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ws-ovpn
systemctl start ws-ovpn
systemctl restart ws-ovpn

rm -f $0
