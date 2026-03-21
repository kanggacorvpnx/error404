#!/bin/bash
# Auto Install Dropbear 2019.78 to /usr/sbin/dropbear
# Oleh: (LT) Lunatic Tunneling

clear

echo "✅ Proses Install Dropbear "
echo -e "\e[93;1m ======================================= \e[0m"
echo -e "\e[95;1m Dropbear Version :\e[92;1m 2019.78 \e[0m"
echo -e "\e[95;1m Dropbear PATH    :\e[92;1m /usr/sbin/dropbear \e[0m"
echo -e "\e[95;1m Dropbear Port    :\e[92;1m 143 \e[0m"
echo -e "\e[95;1m Dropbear ARGS    :\e[92;1m /etc/banner.txt -p 109 -I 60 \e[0m"
echo -e "\e[95;1m Dropbear Enhanced:\e[92;1m Support \e[0m"
echo -e "\e[93;1m ======================================= \e[0m"

sleep 3
clear
echo "[1] Menghapus dropbear versi lama..."
pkill dropbear > /dev/null 2>&1
rm -f /usr/sbin/dropbear
rm -f /usr/local/sbin/dropbear
rm -f /usr/local/bin/dropbear
rm -f /usr/bin/dropbear
rm -rf ~/dropbear-*

echo "[2] Install dependensi..."
apt update -y
apt install -y build-essential zlib1g-dev wget

echo "[3] Download Dropbear 2019.78..."
cd ~
wget -q https://matt.ucc.asn.au/dropbear/releases/dropbear-2019.78.tar.bz2

echo "[4] Extract file..."
tar -xjf dropbear-2019.78.tar.bz2
cd dropbear-2019.78

echo "[5] Konfigurasi dan compile..."
./configure > /dev/null
make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" > /dev/null

echo "[6] Menyalin binary ke /usr/sbin..."
cp dropbear /usr/sbin/
chmod +x /usr/sbin/dropbear

echo "[7] Mengecek versi dropbear..."
/usr/sbin/dropbear -V

clear
echo "✅ Instalasi selesai!"
echo -e "\e[93;1m ======================================= \e[0m"
echo -e "\e[95;1m Dropbear Version :\e[92;1m 2019.78 \e[0m"
echo -e "\e[95;1m Dropbear PATH    :\e[92;1m /usr/sbin/dropbear \e[0m"
echo -e "\e[95;1m Dropbear Port    :\e[92;1m 143 \e[0m"
echo -e "\e[95;1m Dropbear ARGS    :\e[92;1m /etc/banner.txt -p 109 -I 60 \e[0m"
echo -e "\e[95;1m Dropbear Enhanced:\e[92;1m Support \e[0m"
echo -e "\e[93;1m ======================================= \e[0m"

chmod 755 /usr/sbin/dropbear
systemctl restart dropbear

rm -rf dropbear-2019.78
rm -rf dropbear-2019.78.tar.bz2

sleep 3