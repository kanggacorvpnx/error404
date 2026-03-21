#!/bin/bash
# base Scripts : # Bringas Tunnel | Bringas Family @2016
# Create anyewhere : 2016 november 14
# Recoder : Lunatic Tunneling ( LT )
# Autheeer :  Bringas Tunnel
# Bandung Barat | jawa Barat | desa Jati | Indonesia
# Recode ? Jangan Hilangkan Watermark tod bodoh
# awas ada trap , gua masih baik ngasi tau 
export TERM=xterm
export DEBIAN_FRONTEND=noninteractive
dpkg-reconfigure debconf -f noninteractive 2>/dev/null

rm -f $0
clear
echo -e "\e[95;1m================================== \e[0m"
echo -e "\e[93;1m          PACKETS INSTALLER       \e[0m "
echo -e "\e[95;1m================================== \e[0m"
echo -e "\e[92;1m *\e[96;1m update upgrade scripts  \e[0m "
echo -e "\e[92;1m *\e[96;1m installer packet in gets  \e[0m "
echo -e "\e[95;1m================================== \e[0m"

sleep 3
clear
apt update -y
apt upgrade -y
apt install git -y
apt install at -y
apt install curl -y
apt install wget -y
apt install jq -y
apt install lolcat -y
apt install gem -y
gem install lolcat -y
apt install dos2unix -y
apt install python -y
apt install python3 -y
apt install socat -y
apt install netcat -y
apt install ufw -y
apt install telnet 


# buat ubuntu 22 dan 25 
apt install netcat-traditional -y
apt install netcat-openbsd -y
apt install nodejs -y
apt install npm && npm install -g pm2

IPVPS=$(curl -sS ipv4.icanhazip.com)
export IP=$( curl -sS icanhazip.com )

# GIT REPO
LUNAREP="https://raw.githubusercontent.com/kanggacorvpnx/error404/main/"

function ADD_CEEF() {
EMAILCF="newvpnlunatix293@gmail.com"
KEYCF="88a8619c3dec8a0c9a14cf353684036108844"
echo "$EMAILCF" > /usr/bin/emailcf
echo "$KEYCF" > /usr/bin/keycf
}

function check_os_version() {
    local os_id os_version

    os_id=$(grep -w ID /etc/os-release | cut -d= -f2 | tr -d '"')
    os_version=$(grep -w VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')

    case "$os_id" in
        ubuntu)
            case "$os_version" in
                20.04|22.04|22.10|23.04|24.04|24.10|25.04|25.10)
                    echo -e "${OK} Your OS is supported: Ubuntu $os_version"
                    ;;
                *)
                    echo -e "${ERROR} Ubuntu version $os_version is not supported."
                    exit 1
                    ;;
            esac
            ;;
        debian)
            case "$os_version" in
                10|11|12|13)
                    echo -e "${OK} Your OS is supported: Debian $os_version"
                    ;;
                *)
                    echo -e "${ERROR} Debian version $os_version is not supported."
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo -e "${ERROR} Your OS ($os_id $os_version) is not supported."
            exit 1
            ;;
    esac
}

if [[ $( uname -m ) == "x86_64" ]]; then
    echo -e "${OK} Your Architecture Is Supported ( ${green}$( uname -m )${NC} )"
else
    echo -e "${ERROR} Your Architecture Is Not Supported ( ${YELLOW}$( uname -m )${NC} )"
    exit 1
fi

# Cek versi OS
check_os_version


if [ "${EUID}" -ne 0 ]; then
   echo "You need to run this script as root"
   exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
   echo "OpenVZ is not supported"
   exit 1
fi

# =========================[ WARNA ANSI ]=========================
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RED="\e[31m"
NC="\e[0m" # No Color
OK="[${GREEN}OK${NC}]"
ERROR="[${RED}ERROR${NC}]"

BIRU="\033[38;2;0;191;255m"
HIJAU="\033[38;2;173;255;47m"
PUTIH="\033[38;2;255;255;255m"
CYANS="\033[38;2;35;235;195m"
GOLD="\033[38;2;255;215;0m"
RESET="\033[0m"
# =========================[ FUNGSI UTILITAS ]=========================


print_error() {
    echo -e "${ERROR} ${RED}$1${NC}"
}

print_info() {
    echo -e "${YELLOW}[*] $1${NC}"
}

# Menampilkan pesan OK
print_ok() {
    echo -e "${OK} ${BLUE}$1${NC}"
}


# Menampilkan proses instalasi
print_install() {
    echo -e "${BIRU}──────────────────────────────────────${NC}"
    echo -e "${GOLD}# $1${NC}"
    echo -e "${BIRU}──────────────────────────────────────${NC}"
    sleep 1
}


# Menampilkan pesan sukses jika exit code 0
print_success() {
    if [[ $? -eq 0 ]]; then
    echo -e "${BIRU}──────────────────────────────────────${NC}"
    echo -e "${HIJAU}# $1 Sukses!${NC}"
    echo -e "${BIRU}──────────────────────────────────────${NC}"
        sleep 1
    fi
}

# Cek apakah user adalah root
is_root() {
    if [[ $EUID -eq 0 ]]; then
        print_ok "User root terdeteksi. Memulai proses instalasi..."
    else
        print_error "User saat ini bukan root. Silakan gunakan sudo atau login sebagai root!"
        exit 1
    fi
}

# =========================[ PERSIAPAN SISTEM XRAY ]=========================

print_install "Create Dir and Xray Configure"

mkdir -p /etc/xray
curl -s ifconfig.me > /etc/xray/ipvps
touch /etc/xray/domain

mkdir -p /var/log/xray
chown www-data:www-data /var/log/xray
chmod +x /var/log/xray

echo -e "\e[95;1m================================== \e[0m"
echo -e "\e[93;1m       CREATE LOGS VIA TOUCH         \e[0m "
echo -e "\e[95;1m================================== \e[0m"
echo -e "\e[92;1m *\e[96;1m /var/log/xray/access.log  \e[0m "
echo -e "\e[92;1m *\e[96;1m /var/log/xray/error.log  \e[0m "
echo -e "\e[92;1m *\e[96;1m /var/log/auth.log  \e[0m "
echo -e "\e[92;1m *\e[96;1m /var/log/kern.log  \e[0m "
echo -e "\e[92;1m *\e[96;1m /var/log/mail.log  \e[0m "
echo -e "\e[92;1m *\e[96;1m /var/log/user.log  \e[0m "
echo -e "\e[92;1m *\e[96;1m /var/log/cron.log  \e[0m "
echo -e "\e[95;1m================================== \e[0m"
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/auth.log
touch /var/log/kern.log
touch /var/log/mail.log
touch /var/log/user.log
touch /var/log/cron.log

mkdir -p /var/lib/luna >/dev/null 2>&1

print_success "Succesfully✅"

# =========================[ CEK PENGGUNAAN RAM ]=========================
clear
print_install "Menghitung penggunaan RAM"

mem_used=0
mem_total=0

while IFS=":" read -r key value; do
    value_kb=${value//[^0-9]/}  # Hanya ambil angka
    case $key in
        "MemTotal") 
            mem_total=$value_kb
            mem_used=$value_kb
            ;;
        "Shmem") 
            mem_used=$((mem_used + value_kb))
            ;;
        "MemFree" | "Buffers" | "Cached" | "SReclaimable")
            mem_used=$((mem_used - value_kb))
            ;;
    esac
done < /proc/meminfo

Ram_Usage=$((mem_used / 1024))  # dalam MB
Ram_Total=$((mem_total / 1024)) # dalam MB

print_ok "RAM Digunakan : ${Ram_Usage} MB / ${Ram_Total} MB"
sleep 1
# =========================[ INFO SISTEM ]=========================
clear

export tanggal=$(date +"%d-%m-%Y - %X")
export OS_Name=$(grep -w PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
export Kernel=$(uname -r)
export Arch=$(uname -m)
export IP=$(curl -s https://ipinfo.io/ip)

echo -e "\e[95;1m================================== \e[0m"
print_ok "Tanggal     : $tanggal"
print_ok "OS          : $OS_Name"
print_ok "Kernel      : $Kernel"
print_ok "Arsitektur  : $Arch"
print_ok "IP Publik   : $IP"
echo -e "\e[95;1m================================== \e[0m"
# =========================[ FUNGSI SETUP UTAMA ]=========================
sleep 2
clear
PROXY_SETUP() {
    # Set zona waktu ke Asia/Jakarta
    timedatectl set-timezone Asia/Jakarta
    print_success "Timezone diset ke Asia/Jakarta"

    # Otomatis simpan aturan iptables
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

    # Ambil OS info
    OS_ID=$(grep -w ^ID /etc/os-release | cut -d= -f2 | tr -d '"')
    OS_NAME=$(grep -w PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')

    print_success "Direktori Xray berhasil disiapkan"

# ubuntu
    # Instalasi tergantung distribusi OS
    if [[ "$OS_ID" == "ubuntu" ]]; then
        print_info "Deteksi OS: $OS_NAME"
        print_info "Menyiapkan dependensi untuk Ubuntu..."

        apt-get install haproxy -y
        apt install haproxy -y
        apt-get install nginx -y
        apt install nginx -y
        systemctl stop haproxy
        systemctl stop nginx

        print_success "HAProxy untuk Ubuntu ${OS_ID} telah terinstal"

## debian
    elif [[ "$OS_ID" == "debian" ]]; then
        print_info "Deteksi OS: $OS_NAME"
        print_info "Menyiapkan dependensi untuk Debian..."

        apt install haproxy -y
        apt install nginx -y        
        systemctl stop haproxy
        systemctl stop nginx
        
        print_success "HAProxy untuk Debian ${OS_ID} telah terinstal"

    else
        print_error "OS Tidak Didukung: $OS_NAME"
        exit 1
    fi
}

TOOLS_SETUP() {
    clear
    print_install "Install packet scripts Lunatic Tunneling v3"

    # Paket utama
    apt update -y
    apt upgrade -y
    apt dist-upgrade -y

    # Paket dasar
    apt install -y \
        zip pwgen openssl netcat socat cron bash-completion figlet sudo \
        zip unzip p7zip-full screen git cmake make build-essential \
        gnupg gnupg2 gnupg1 apt-transport-https lsb-release jq htop lsof tar \
        dnsutils python3-pip python ruby ca-certificates bsd-mailx msmtp-mta \
        ntpdate chrony chronyd ntpdate easy-rsa openvpn \
        net-tools rsyslog dos2unix sed xz-utils libc6 util-linux shc gcc g++ \
        libnss3-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev \
        libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison \
        libnss3-tools libevent-dev zlib1g-dev libssl-dev libsqlite3-dev \
        libxml-parser-perl dirmngr

    # Bersih-bersih dan setting iptables-persistent
clear
echo -e "\e[95;1m================================== \e[0m"
echo -e "\e[93;1m    CLEAN AND IPTABLES SETTINGS         \e[0m "
echo -e "\e[95;1m================================== \e[0m"
echo -e "\e[92;1m *\e[96;1m Remove exim4  \e[0m "
echo -e "\e[92;1m *\e[96;1m Remove ufw  \e[0m "
echo -e "\e[92;1m *\e[96;1m Remove firewal  \e[0m "
echo -e "\e[95;1m================================== \e[0m"
echo ""    
    sudo apt-get clean all
    sudo apt-get autoremove -y
    sudo apt-get remove --purge -y exim4 ufw firewall
    sudo apt-get install -y debconf-utils

    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    apt install -y iptables iptables-persistent netfilter-persistent
    
    apt install rsyslog -y
    # Sinkronisasi waktu
    systemctl enable chronyd chrony
    systemctl restart chronyd chrony
    systemctl restart syslog
    ntpdate pool.ntp.org
    chronyc sourcestats -v
    chronyc tracking -v

    print_success "iptabless settings succes"
}

DOMENS_SETUP() {
clear
# === CREDENTIAL CLOUDFLARE ===
CF_ID="newvpnlunatix293@gmail.com"
CF_KEY="88a8619c3dec8a0c9a14cf353684036108844"

# === DOMAIN UTAMA ===
DOMAIN="execshell.cloud"
IPVPS=$(curl -s ipv4.icanhazip.com)

# === Generate Subdomain Random ===
SUBDOMAIN=$(cat /dev/urandom | tr -dc a-z0-9 | head -c 5)
RECORD="$SUBDOMAIN.$DOMAIN"

# === Get Zone ID dari Cloudflare ===
ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$DOMAIN" \
     -H "X-Auth-Email: $CF_ID" \
     -H "X-Auth-Key: $CF_KEY" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

# === Cek apakah record sudah ada ===
RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$RECORD" \
     -H "X-Auth-Email: $CF_ID" \
     -H "X-Auth-Key: $CF_KEY" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

# === Tambah / Update Record ===
if [[ "$RECORD_ID" == "null" ]]; then
  echo "➕ Menambahkan record baru: $RECORD"
  curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
       -H "X-Auth-Email: $CF_ID" \
       -H "X-Auth-Key: $CF_KEY" \
       -H "Content-Type: application/json" \
       --data "{\"type\":\"A\",\"name\":\"$RECORD\",\"content\":\"$IPVPS\",\"ttl\":120,\"proxied\":false}" > /dev/null
else
  echo "🔄 Mengupdate record lama: $RECORD"
  curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
       -H "X-Auth-Email: $CF_ID" \
       -H "X-Auth-Key: $CF_KEY" \
       -H "Content-Type: application/json" \
       --data "{\"type\":\"A\",\"name\":\"$RECORD\",\"content\":\"$IPVPS\",\"ttl\":120,\"proxied\":false}" > /dev/null
fi

# === Simpan Hasil Domain ke File (APPEND) ===
echo "$RECORD" >> /etc/xray/domain 
echo "$RECORD" >> ~/domain # /root/domain
}


#!/bin/bash
# ==============================
# SCRIPT SETUP DOMAIN XRAY
# ==============================

# === CREDENTIAL CLOUDFLARE ===
CF_ID="newvpnlunatix293@gmail.com"
CF_KEY="88a8619c3dec8a0c9a14cf353684036108844"

# === DOMAIN UTAMA ===
DOMAIN="execshell.cloud"
IPVPS=$(curl -s ipv4.icanhazip.com)

# ==============================
# MENU PILIHAN DOMAIN
# ==============================
DOMAIN_MENU() {
clear
echo -e "\e[95;1m================================== \e[0m"
echo -e "\e[93;1m      SETUP DOMAIN TUNNELING       \e[0m "
echo -e "\e[95;1m================================== \e[0m"
echo -e "\e[92;1m 1.\e[96;1m Random Domain    \e[0m"
echo -e "\e[92;1m 2.\e[96;1m Custom Domain     \e[0m"
echo -e "\e[95;1m================================== \e[0m"
read -p " Just Input 1-2 : " pilih

case $pilih in
1)
    DOMENS_SETUP
    ;;
2)
    CUSTOM_DOMAIN
    ;;
*)
    echo "❌ Pilihan tidak valid"
    sleep 2
    DOMAIN_MENU
    ;;
esac
}

# ==============================
# OPSI 1: RANDOM DOMAIN (DEFAULT)
# ==============================
DOMENS_SETUP() {
clear
# === Generate Subdomain Random ===
SUBDOMAIN=$(tr -dc a-z0-9 </dev/urandom | head -c 5)
RECORD="$SUBDOMAIN.$DOMAIN"

# === Get Zone ID ===
ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$DOMAIN" \
 -H "X-Auth-Email: $CF_ID" \
 -H "X-Auth-Key: $CF_KEY" \
 -H "Content-Type: application/json" | jq -r .result[0].id)

# === Get Record ID ===
RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$RECORD" \
 -H "X-Auth-Email: $CF_ID" \
 -H "X-Auth-Key: $CF_KEY" \
 -H "Content-Type: application/json" | jq -r .result[0].id)

# === Add / Update Record ===
if [[ "$RECORD_ID" == "null" ]]; then
  echo "➕ Menambahkan domain: $RECORD"
  curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
   -H "X-Auth-Email: $CF_ID" \
   -H "X-Auth-Key: $CF_KEY" \
   -H "Content-Type: application/json" \
   --data "{\"type\":\"A\",\"name\":\"$RECORD\",\"content\":\"$IPVPS\",\"ttl\":120,\"proxied\":false}" > /dev/null
else
  echo "🔄 Update domain: $RECORD"
  curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
   -H "X-Auth-Email: $CF_ID" \
   -H "X-Auth-Key: $CF_KEY" \
   -H "Content-Type: application/json" \
   --data "{\"type\":\"A\",\"name\":\"$RECORD\",\"content\":\"$IPVPS\",\"ttl\":120,\"proxied\":false}" > /dev/null
fi

# === Simpan Domain ===
clear
echo -e "\e[95;1m================================== \e[0m"
echo -e "\e[93;1m           SAVED DOMAINS               \e[0m "
echo -e "\e[95;1m================================== \e[0m"
echo "$RECORD" | tee -a /etc/xray/domain ~/domain
sleep 2
clear
echo "✅ DOMAIN ONLINE: $RECORD"
echo -e "\e[95;1m================================== \e[0m"
echo -e "\e[93;1m        DOMAIN ONLINE SUCCES         \e[0m "
echo -e "\e[95;1m================================== \e[0m"
echo -e "\e[92;1m *\e[96;1m domain udp Zivpn             \e[0m "
echo -e "\e[92;1m *\e[96;1m domain udp Custom           \e[0m "
echo -e "\e[92;1m *\e[96;1m domain sshws 0penvpn        \e[0m "
echo -e "\e[92;1m *\e[96;1m domain x-Ray Vmess           \e[0m "
echo -e "\e[92;1m *\e[96;1m domain x-Ray Vless            \e[0m "
echo -e "\e[92;1m *\e[96;1m domain x-Ray Trojan           \e[0m "
echo -e "\e[95;1m================================== \e[0m"
sleep 3
}

# ==============================
# OPSI 2: CUSTOM DOMAIN
# ==============================
CUSTOM_DOMAIN() {
clear
echo -e "\e[95;1m================================== \e[0m"
echo -e "\e[93;1m      CUSTOM DOMAIN TUNNELING       \e[0m "
echo -e "\e[95;1m================================== \e[0m"
echo -e "\e[92;1m *\e[96;1m pastikan anda sudah Mempointing  \e[0m "
echo -e "\e[92;1m *\e[96;1m IPVPS anda Ke DOMAIN             \e[0m "
echo -e "\e[95;1m================================== \e[0m"
read -p "Input domain: " CDOMAIN

if [[ -z "$CDOMAIN" ]]; then
  echo "❌ Domain tidak boleh kosong"
  sleep 2
  CUSTOM_DOMAIN
fi

# === Simpan Domain ===
echo "$CDOMAIN" | tee -a /etc/xray/domain ~/domain
echo "✅ Domain custom digunakan: $CDOMAIN"
sleep 2
}



SSL_SETUP() {
    clear
    print_install "Memasang SSL Certificate pada domain"

    # Cek domain
    if [[ ! -f /root/domain ]]; then
        print_error "File /root/domain tidak ditemukan!"
        return 1
    fi

    domain=$(cat /root/domain)

    # Hentikan service yang menggunakan port 80
    webserver_port=$(lsof -i:80 | awk 'NR==2 {print $1}')
    if [[ -n "$webserver_port" ]]; then
        print_info "Menghentikan service $webserver_port yang menggunakan port 80..."
        systemctl stop "$webserver_port"
    fi

    systemctl stop nginx >/dev/null 2>&1

    # Hapus sertifikat lama
    rm -f /etc/xray/xray.key /etc/xray/xray.crt
    rm -rf /root/.acme.sh
    mkdir -p /root/.acme.sh

    # Download ACME.sh
    curl -s https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
    chmod +x /root/.acme.sh/acme.sh

    # Upgrade dan konfigurasi ACME
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt

    # Proses issue SSL
    /root/.acme.sh/acme.sh --issue -d "$domain" --standalone -k ec-256
    if [[ $? -ne 0 ]]; then
        print_error "Gagal mendapatkan sertifikat SSL dari Let's Encrypt"
        return 1
    fi

    # Pasang sertifikat ke direktori Xray
    ~/.acme.sh/acme.sh --installcert -d "$domain" \
        --fullchainpath /etc/xray/xray.crt \
        --keypath /etc/xray/xray.key \
        --ecc

    chmod 600 /etc/xray/xray.key /etc/xray/xray.crt

    print_success "Sertifikat SSL berhasil dipasang untuk domain: $domain"
}

# Bikin Dir path
FODER_SETUP() {
local main_dirs=(
        "/etc/xray" "/var/lib/luna" "/etc/lunatic" "/etc/limit" "/etc/zivpn"
        "/etc/vmess" "/etc/vless" "/etc/trojan" "/etc/ssh" "/usr/local/bin" 
    )
    
    local lunatic_subdirs=("vmess" "vless" "trojan" "ssh" "bot" "zivpn")
    local lunatic_types=("usage" "ip" "detail")

    local protocols=("vmess" "vless" "trojan" "ssh" "zivpn")

    for dir in "${main_dirs[@]}"; do
        mkdir -p "$dir"
    done

    for service in "${lunatic_subdirs[@]}"; do
        for type in "${lunatic_types[@]}"; do
            mkdir -p "/etc/lunatic/$service/$type"
        done
    done

    for protocol in "${protocols[@]}"; do
        mkdir -p "/etc/limit/$protocol"
    done

    local databases=(
        "/etc/lunatic/vmess/.vmess.db"
        "/etc/lunatic/vless/.vless.db"
        "/etc/lunatic/trojan/.trojan.db"
        "/etc/lunatic/ssh/.ssh.db"
        "/etc/lunatic/bot/.bot.db"
    )

    for db in "${databases[@]}"; do
        touch "$db"
        echo "& plugin Account" >> "$db"
    done

    touch /etc/.{ssh,vmess,vless,trojan}.db
    echo "IP=" > /var/lib/luna/ipvps.conf
}

XRAY_SETUP() {
    clear
    print_install "Xray Core version 26"

    # Buat directory untuk socket domain jika belum ada
    local domainSock_dir="/run/xray"
    [[ ! -d $domainSock_dir ]] && mkdir -p "$domainSock_dir"
    chown www-data:www-data "$domainSock_dir"
    # Install Xray Core versi v24
    # bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 24.10.31
    
    # XRAY TERBARU VERSI V26
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data
    # Konfigurasi file dan service custom
    wget -q -O /etc/xray/config.json "${LUNAREP}configure/config.json"
    wget -q -O /etc/systemd/system/runn.service "${LUNAREP}configure/runn.service"

    # Validasi domain
    if [[ ! -f /etc/xray/domain ]]; then
        print_error "File domain tidak ditemukan di /etc/xray/domain"
        return 1
    fi
    local domain=$(cat /etc/xray/domain)
    local IPVS=$(cat /etc/xray/ipvps)

    clear
    print_success "Xray Core v26 succes"
    clear

    # Tambahkan info kota dan ISP
    curl -s ipinfo.io/city >> /etc/xray/city
    curl -s ipinfo.io/org | cut -d " " -f 2- >> /etc/xray/isp
    
    clear
    print_install "Install .cfg .conf .service "

    wget -q -O /etc/haproxy/haproxy.cfg "${LUNAREP}configure/haproxy.cfg"
    wget -q -O /etc/nginx/conf.d/xray.conf "${LUNAREP}configure/xray.conf"
    curl -s "${LUNAREP}configure/nginx.conf" > /etc/nginx/nginx.conf

    # Ganti placeholder domain
    sed -i "s/xxx/${domain}/g" /etc/haproxy/haproxy.cfg
    sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf

    # Gabungkan sertifikat ke haproxy
    cat /etc/xray/xray.crt /etc/xray/xray.key > /etc/haproxy/hap.pem

    # Tambahkan service unit untuk xray
    cat > /etc/systemd/system/xray.service <<EOF
[Unit]
Description=Xray Service
Documentation=https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF

    chmod +x /etc/systemd/system/runn.service
    rm -rf /etc/systemd/system/xray.service.d

    print_success "Settings xray, service and config succes"
}

PW_DEFAULT() {
    clear
    print_install "Set PASSWORD"

    # Download file konfigurasi password PAM
    local password_url="https://raw.githubusercontent.com/kanggacorvpnx/error404/main/configure/password"
    wget -q -O /etc/pam.d/common-password "$password_url"
    chmod 644 /etc/pam.d/common-password

    # Konfigurasi layout keyboard non-interaktif
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure keyboard-configuration

    debconf-set-selections <<EOF
keyboard-configuration keyboard-configuration/layout select English
keyboard-configuration keyboard-configuration/layoutcode string us
keyboard-configuration keyboard-configuration/model select Generic 105-key (Intl) PC
keyboard-configuration keyboard-configuration/modelcode string pc105
keyboard-configuration keyboard-configuration/variant select English
keyboard-configuration keyboard-configuration/variantcode string
keyboard-configuration keyboard-configuration/store_defaults_in_debconf_db boolean true
keyboard-configuration keyboard-configuration/altgr select The default for the keyboard layout
keyboard-configuration keyboard-configuration/compose select No compose key
keyboard-configuration keyboard-configuration/switch select No temporary switch
keyboard-configuration keyboard-configuration/toggle select No toggling
keyboard-configuration keyboard-configuration/ctrl_alt_bksp boolean false
keyboard-configuration keyboard-configuration/unsupported_config_layout boolean true
keyboard-configuration keyboard-configuration/unsupported_config_options boolean true
keyboard-configuration keyboard-configuration/unsupported_layout boolean true
keyboard-configuration keyboard-configuration/unsupported_options boolean true
EOF

    # Konfigurasi systemd rc-local agar bisa eksekusi skrip tambahan saat boot
    cat > /etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local compatibility
ConditionPathExists=/etc/rc.local
After=network.target

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
EOF

    # Isi default dari rc.local
    cat > /etc/rc.local <<EOF
#!/bin/bash
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
exit 0
EOF

    chmod +x /etc/rc.local
    systemctl enable rc-local.service
    systemctl start rc-local.service

    # Nonaktifkan IPv6 secara langsung juga saat ini
    echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6

    # Set zona waktu Jakarta
    ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

    # Nonaktifkan AcceptEnv agar tidak override env SSH
    sed -i 's/^AcceptEnv/#AcceptEnv/' /etc/ssh/sshd_config

    # Restart SSH jika dibutuhkan
    systemctl restart ssh

    print_success "SSH configure & Password Policy"
}


LIMIT_HANDLER() {
    clear
    print_install "create in set LimitHandler"

    # Download dan jalankan install.sh untuk setup awal
    wget https://raw.githubusercontent.com/kanggacorvpnx/error404/main/LimitHandler/install.sh && chmod +x install.sh && ./install.sh

    # Download file limit-ip ke /usr/bin/
    cd
    wget -q -O /usr/bin/limit-ip "${LUNAREP}LimitHandler/limit-ip"
    chmod +x /usr/bin/limit-ip
    sed -i 's/\r//' /usr/bin/limit-ip

    # Buat dan aktifkan systemd service untuk VMess IP limit
    cat >/etc/systemd/system/vmip.service << EOF
[Unit]
Description=VMess IP Limiter
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip vmip
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable --now vmip

    # Buat dan aktifkan service untuk VLESS IP limit
    cat >/etc/systemd/system/vlip.service << EOF
[Unit]
Description=VLESS IP Limiter
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip vlip
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable --now vlip

    # Buat dan aktifkan service untuk Trojan IP limit
    cat >/etc/systemd/system/trip.service << EOF
[Unit]
Description=Trojan IP Limiter
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip trip
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable --now trip

    # Pasang dan beri izin eksekusi untuk udp-mini
    mkdir -p /usr/local/lunatic
    wget -q -O /usr/local/lunatic/udp-mini "${LUNAREP}configure/udp-mini"
    chmod +x /usr/local/lunatic/udp-mini

    # Download dan pasang 3 service UDP Mini berbeda (multi-instance)
    for i in 1 2 3; do
        wget -q -O /etc/systemd/system/udp-mini-$i.service "${LUNAREP}configure/udp-mini-$i.service"
        systemctl daemon-reload
        systemctl enable --now udp-mini-$i
    done

    print_success "succes in set LimitHandler"
}

SLOWDNS_SETUP(){
clear
print_install "SlowDNS Server"
wget -q -O /tmp/nameserver "${LUNAREP}configure/nameserver" >/dev/null 2>&1
chmod +x /tmp/nameserver
bash /tmp/nameserver | tee /root/install.log
print_success "SlowDNS"
}


# ========================================
# Fungsi: Install dan Konfigurasi SSHD
# ========================================
SSHD_SETUP(){
    clear
    print_install "SSHD"

    # Download konfigurasi SSH dari repo
    wget -q -O /etc/ssh/sshd_config "${LUNAREP}configure/sshd" >/dev/null 2>&1

    # Atur permission file konfigurasi
    chmod 700 /etc/ssh/sshd_config

    # Restart layanan SSH
    /etc/init.d/ssh restart
    systemctl restart ssh

    print_success "SSHD"
}

# ========================================
# Fungsi: Install dan Konfigurasi Dropbear
# ========================================
DROPBEAR_SETUP(){
    clear
    print_install "Lunatic scripts Dropbear version 2019.78"

    # Install Dropbear
    apt install dropbear -y > /dev/null 2>&1
    
    # Install dropbear Versi 2019.78
    wget ${LUNAREP}install-dropbear.sh && chmod +x install-dropbear.sh && ./install-dropbear.sh
    # Download konfigurasi dropbear
    wget -q -O /etc/default/dropbear "${LUNAREP}configure/dropbear.conf"

    # Pastikan file bisa dieksekusi
    chmod +x /etc/default/dropbear
    chmod 600 /etc/default/dropbear
    
    chmod 755 /usr/sbin/dropbear
    # Restart Dropbear dan tampilkan status
    /etc/init.d/dropbear restart    
    print_success "Dropbear"
}

# ========================================
# Fungsi: Install dan Konfigurasi Vnstat
# ========================================
vnSTATS_SETUP(){
    clear
    print_install "Bandwidth Vnstat"

    # Install vnstat dari repository
    apt -y install vnstat > /dev/null 2>&1
    /etc/init.d/vnstat restart

    # Install dependency untuk compile manual
    apt -y install libsqlite3-dev > /dev/null 2>&1

    # Download dan ekstrak source vnstat versi terbaru
    wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
    tar zxvf vnstat-2.6.tar.gz

    # Compile dan install vnstat
    cd vnstat-2.6
    ./configure --prefix=/usr --sysconfdir=/etc && make && make install
    cd

    # Inisialisasi database vnstat untuk interface tertentu
    vnstat -u -i $NET

    # Sesuaikan konfigurasi interface
    sed -i "s/Interface \"eth0\"/Interface \"$NET\"/g" /etc/vnstat.conf

    # Set hak akses direktori data vnstat
    chown vnstat:vnstat /var/lib/vnstat -R

    # Aktifkan dan restart vnstat
    systemctl enable vnstat
    /etc/init.d/vnstat restart
    /etc/init.d/vnstat status

    # Bersihkan file installer
    rm -f /root/vnstat-2.6.tar.gz
    rm -rf /root/vnstat-2.6

    print_success "Vnstat"
}
OPVPN_SETUP() {
    clear
    print_install "OpenVPN"

    # Unduh installer OpenVPN dari repo Anda, beri izin eksekusi, lalu jalankan
    wget ${LUNAREP}configure/openvpn
    chmod +x openvpn
    ./openvpn

    # Restart layanan OpenVPN
    /etc/init.d/openvpn restart

    print_success "OpenVPN"
}


RCLONE_SETUP() {
    clear
    print_install "Wondershaper And Rclone"

    # Instalasi rclone
    apt install rclone -y
    printf "q\n" | rclone config

    # Unduh konfigurasi rclone
    wget -O /root/.config/rclone/rclone.conf "${LUNAREP}configure/rclone.conf"

    # Clone dan install wondershaper untuk manajemen bandwidth
    cd /bin
    git clone https://github.com/LunaticTunnel/wondershaper.git
    cd wondershaper
    sudo make install
    cd ~
    rm -rf wondershaper

    # Buat file dummy untuk backup (kalau belum ada)
    echo > /home/files

    # Install tool pengirim email
    apt install msmtp-mta ca-certificates bsd-mailx -y

    # Konfigurasi msmtp (pengiriman email backup via Gmail SMTP)
    cat <<EOF > /etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
account default
host smtp.gmail.com
port 587
auth on
user oceantestdigital@gmail.com
from oceantestdigital@gmail.com
password jokerman77
logfile ~/.msmtp.log
EOF

    # Ubah permission agar bisa diakses oleh webserver jika perlu
    chown -R www-data:www-data /etc/msmtprc

    # Download file ipserver dan eksekusi
    wget -q -O /etc/ipserver "${LUNAREP}configure/ipserver" && bash /etc/ipserver

    print_success "Wondershaper and Rclone"
}


# Fungsi: Menginstall swap 1GB dan alat monitoring gotop
SWAPRAM_SETUP(){
    clear
    print_install "Swap RAM 2 GB and TCP BBR"

    # Mengambil versi terbaru gotop
    gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v${gotop_latest}_linux_amd64.deb"

    # Download & install gotop
    curl -sL "$gotop_link" -o /tmp/gotop.deb
    dpkg -i /tmp/gotop.deb >/dev/null 2>&1

    # Membuat swap file 2GB
    dd if=/dev/zero of=/swapfile bs=1M count=2048
    mkswap /swapfile
    chown root:root /swapfile
    chmod 600 /swapfile
    swapon /swapfile >/dev/null 2>&1

# swap 1 Gb untuk ram 1
    fallocate -l 1G /swapfile2
    chmod 600 /swapfile2
    mkswap /swapfile2
    swapon /swapfile2
         
    # Tambahkan swap ke fstab agar aktif saat boot
    sed -i '$ i\/swapfile swap swap defaults 0 0' /etc/fstab

    # Sinkronisasi waktu dengan server Indonesia
    chronyd -q 'server 0.id.pool.ntp.org iburst'
    chronyc sourcestats -v
    chronyc tracking -v

    # Download dan jalankan script BBR dari repo LUNAREP
    wget ${LUNAREP}configure/bbr.sh && chmod +x bbr.sh && ./bbr.sh

    print_success "Swap RAM 2 GB and TCP BBR"
}

# Fungsi: Menginstall Fail2ban dan setup banner SSH
FAIL2BAN_SETUP(){
    clear
    print_install "Fail2ban & Issue.net"

    # Cek apakah folder DDOS sudah ada
    if [ -d '/usr/local/ddos' ]; then
        echo; echo; echo "Please un-install the previous version first"
        exit 0
    else
        mkdir /usr/local/ddos
    fi

    # Menambahkan banner login ke SSH
    echo "Banner /etc/banner.txt" >> /etc/ssh/sshd_config
    sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/banner.txt"@g' /etc/default/dropbear

    # Download file banner dari server
    wget -O /etc/banner.txt "${LUNAREP}banner/issue.net"

    print_success "Fail2ban & Issue.net"
}

WEBSOCKET_SETUP() {
    clear
    print_install "ePro WebSocket Proxy and geoip geosite"

    
    # Variabel file & URL
    local ws_bin="/usr/bin/ws"
    local tun_conf="/usr/bin/tun.conf"
    local ws_service="/etc/systemd/system/ws.service"
    local ltvpn_bin="/usr/sbin/ltvpn"
    local rclone_root="/root/.config/rclone/rclone.conf"
    local geosite="/usr/local/share/xray/geosite.dat"
    local geoip="/usr/local/share/xray/geoip.dat"

    # Unduh file binary dan konfigurasi    
    echo -e "\e[95;1m================================== \e[0m"
    echo -e "\e[93;1m      INSTALL WS BINARY         \e[0m "
    echo -e "\e[95;1m================================== \e[0m"
    wget -q -O "$ws_bin" "${LUNAREP}configure/ws"
    sleep 2
    echo -e "\e[95;1m================================== \e[0m"
    echo -e "\e[93;1m      INSTALL tun.conf         \e[0m "
    echo -e "\e[95;1m================================== \e[0m"    
    wget -q -O "$tun_conf" "${LUNAREP}configure/tun.conf"
    sleep 2
    echo -e "\e[95;1m================================== \e[0m"
    echo -e "\e[93;1m      INSTALL WS SERVICE         \e[0m "
    echo -e "\e[95;1m================================== \e[0m"    
    wget -q -O "$ws_service" "${LUNAREP}configure/ws.service"
    sleep 2
    echo -e "\e[95;1m================================== \e[0m"
    echo -e "\e[93;1m      INSTALL rclone.conf         \e[0m "
    sleep 2
    echo -e "\e[95;1m================================== \e[0m"    
    wget -q -O "$rclone_root" "${LUNAREP}configure/rclone.conf"
    sleep 2
    clear
    echo -e "\e[95;1m================================== \e[0m"
    echo -e "\e[93;1m   INSTALL CONNECTED ws.py    \e[0m "
    echo -e "\e[95;1m================================== \e[0m"    
    wget ${LUNAREP}configure/dirmeluna.sh && chmod +x dirmeluna.sh && ./dirmeluna.sh
    clear
    # Izin akses
    chmod +x "$ws_bin"
    chmod 644 "$tun_conf"
    chmod +x "$ws_service"
    
    # Konfigurasi layanan systemd
    systemctl disable ws >/dev/null 2>&1
    systemctl stop ws >/dev/null 2>&1
    systemctl enable ws
    systemctl start ws
    systemctl restart ws
    systemctl restart socks
    clear
    echo -e "\e[95;1m================================== \e[0m"
    echo -e "\e[93;1m      INSTALL GEOIP & GEOSITE         \e[0m "
    echo -e "\e[95;1m================================== \e[0m"    
    # Update file geoip dan geosite untuk XRAY
    wget -q -O "$geosite" "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
    wget -q -O "$geoip" "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
    clear
    
    # Unduh binary ftvpn
    echo -e "\e[95;1m================================== \e[0m"
    echo -e "\e[93;1m   INSTALL BINARY ltvpn    \e[0m "
    echo -e "\e[95;1m================================== \e[0m"        
    wget -q -O "$ltvpn_bin" "${LUNAREP}configure/ltvpn"
    chmod +x "$ftvpn_bin"

    # Blokir lalu lintas BitTorrent via iptables
    local patterns=(
        "get_peers" "announce_peer" "find_node"
        "BitTorrent" "BitTorrent protocol" "peer_id="
        ".torrent" "announce.php?passkey=" "torrent"
        "announce" "info_hash"
    )
    for pattern in "${patterns[@]}"; do
        iptables -A FORWARD -m string --string "$pattern" --algo bm -j DROP
    done

    # Simpan aturan iptables
    iptables-save > /etc/iptables.up.rules
    iptables-restore < /etc/iptables.up.rules
    netfilter-persistent save
    netfilter-persistent reload

    # Bersihkan cache apt
    apt autoclean -y >/dev/null 2>&1
    apt autoremove -y >/dev/null 2>&1

    print_success "ePro WebSocket Proxy and geoip geosite"
}

RESTART_SERVICE() {
    clear
    print_install "Restarting All Packet"

    # Restart service via init.d
    for srv in nginx openvpn ssh dropbear vnstat cron; do
        /etc/init.d/$srv restart
    done

    # Restart systemd-based service
    systemctl restart haproxy

    # Enable semua service penting agar otomatis jalan saat boot
    for srv in nginx xray rc-local dropbear openvpn cron haproxy netfilter-persistent ws; do
        systemctl enable --now $srv
    done

    # Reload systemctl
    systemctl daemon-reexec

    # Bersihkan history
    history -c
    echo "unset HISTFILE" >> /etc/profile

    # Bersihkan file temporer
    rm -f /root/openvpn /root/key.pem /root/cert.pem

    print_success "All services restarted & enabled"
}

function MENU_SETUP() {
clear

# ====== CONFIG ======
TARGET_DIR="/usr/local/sbin"

# ====== PRIVATE KEY (HARUS SAMA DENGAN DECRYPT) ======
_k1='c2Vj'
_k2='cmV0'
_k3='MTIz'
KEY="$(printf '%s%s%s' "$_k1" "$_k2" "$_k3" | base64 -d)"

encrypt_file() {
  f="$1"

  # skip jika bukan file
  [ ! -f "$f" ] && return

  # skip file yang sudah encrypted
  grep -q "__PAYLOAD_BELOW__" "$f" 2>/dev/null && return

  tmp="${f}.tmp"

  {
cat <<'EOF'
#!/bin/sh
_k1='c2Vj'
_k2='cmV0'
_k3='MTIz'
KEY="$(printf '%s%s%s' "$_k1" "$_k2" "$_k3" | base64 -d)"

TMPDIR=${TMPDIR:-/tmp}
dir=$(mktemp -d "$TMPDIR/gztmpXXXX") || exit 1
trap 'rm -rf "$dir"' EXIT

payload="$dir/app"

sed '1,/^__PAYLOAD_BELOW__$/d' "$0" \
| openssl enc -aes-256-cbc -d -pbkdf2 -pass pass:"$KEY" 2>/dev/null \
| gzip -cd > "$payload" || exit 127

chmod +x "$payload"
exec "$payload" "$@"

__PAYLOAD_BELOW__
EOF

  gzip -c9 "$f" \
  | openssl enc -aes-256-cbc -pbkdf2 -salt -pass pass:"$KEY"
  } > "$tmp" || return

  chmod +x "$tmp"
  mv "$tmp" "$f"
}

# ============================
echo -e "\033[32;1m Install packages.... \033[0m"
apt update -y
apt install -y unzip dos2unix openssl gzip -y

clear
echo -e "\033[32;1m Download feature.... \033[0m"

wget https://raw.githubusercontent.com/kanggacorvpnx/error404/main/feature/LUNAVPN >/dev/null 2>&1
unzip LUNAVPN >/dev/null 2>&1

chmod +x menu/*
mv menu/* "$TARGET_DIR"
dos2unix "$TARGET_DIR/welcome"

# ============================
# AUTO ENCRYPT SEMUA FILE
# ============================
echo -e "\033[33;1m Encrypting Scripts........\033[0m"

for f in "$TARGET_DIR"/*; do
  encrypt_file "$f"
done

# ============================
rm -rf menu
rm -rf LUNAVPN

clear
echo -e "\033[31;1m ============================ \033[0m"
echo -e "\033[32;1m Script successfully updated \033[0m"
echo -e "\033[31;1m ============================ \033[0m"
}

BASHRC_PROFILE() {
clear
cat >/root/.profile <<EOF
if [ "$BASH" ]; then
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
fi
mesg n || true
welcome
EOF
}

# Tambah Swap 1GB
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Tambahkan ke fstab agar aktif setelah reboot
if ! grep -q "/swapfile" /etc/fstab; then
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

# install sysctl.conf
    echo -e "\e[95;1m================================== \e[0m"
    echo -e "\e[93;1m   INSTALL CONFIGURE sysctl.conf    \e[0m "
    echo -e "\e[95;1m================================== \e[0m"    
wget https://raw.githubusercontent.com/kanggacorvpnx/error404/main/configure/sysctl.conf && mv sysctl.conf /etc/
sysctl -p
clear
# ================================================
#     LUNATIC SYSTEM - CRONJOBS & AUTOSETUP
# ================================================

# === Cron: Auto-Expired Akun ===
cat > /etc/cron.d/xp_all <<-CRON
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/local/sbin/xp
CRON

# === Cron: Bersihkan Log Setiap 6 jam ===
cat > /etc/cron.d/cleansheat <<-CRON
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 */6 * * * /usr/local/sbin/clearlog
CRON

# === Cron: Reboot Otomatis Jam 5 Pagi ===
cat > /etc/cron.d/daily_reboot <<-CRON
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /usr/local/sbin/reboot
CRON

# === Restart Cron Service ===
service cron restart

# === Simpan Waktu Reboot Harian (5) ===
echo "5" > /home/daily_reboot

# === Konfigurasi rc-local systemd (untuk iptables dan startup command) ===
cat > /etc/systemd/system/rc-local.service <<-EOF
[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
EOF

# === Tambahkan Shell Non-Login untuk Keamanan ===
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells

# === Buat rc.local dengan aturan iptables untuk DNS UDP ===
cat > /etc/rc.local <<-EOF
#!/bin/sh -e
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
systemctl restart netfilter-persistent
exit 0
EOF

chmod +x /etc/rc.local
systemctl daemon-reload
systemctl enable rc-local
systemctl stary rc-rocal

# === Tambahan Informasi ===
AUTOREB=$(cat /home/daily_reboot)
SETT=11
if [ "$AUTOREB" -gt "$SETT" ]; then
    TIME_DATE="PM"
else
    TIME_DATE="AM"
fi

# === Output Informasi Sukses ===
echo -e "\e[92m✅ Cron dan Autostart Berhasil Ditetapkan ($TIME_DATE)\e[0m"

# ==========================================
# Function: ENABLED_SERVICE
# Deskripsi: Mengaktifkan dan me-restart layanan penting
# ==========================================
ENABLED_SERVICE() {
    clear
    print_install "Mengaktifkan Layanan Sistem..."

    systemctl daemon-reload
    systemctl start netfilter-persistent

    # Enable layanan penting saat boot
    systemctl enable --now rc-local
    systemctl enable --now cron
    systemctl enable --now netfilter-persistent

    # Restart service utama
    systemctl restart nginx
    systemctl restart xray
    systemctl restart cron
    systemctl restart haproxy
    systemctl restart dropbear
    systemctl restart ws
    systemctl restart ssh
    systemctl restart socks
    systemctl restart vlip
    systemctl restart vmip
    systemctl restart trip
    systemctl restart syslog
    print_success "Layanan Diaktifkan"
    clear
}
REBUILD_INSTALL() {
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh
mv reinstall.sh /usr/bin
chmod +x /usr/bin/reinstall.sh
}

function SET_DETEK_SSH() {
  detect_os() {
    if [[ -f /etc/os-release ]]; then
      source /etc/os-release
      echo "$ID $VERSION_ID"
    else
      echo "unknown"
    fi
  }

  os_version=$(detect_os)

  case "$os_version" in
    "debian 10"|"debian 11"|"debian 12"|"debian 13")
      RSYSLOG_FILE="/etc/rsyslog.conf"
      ;;
    "ubuntu 20"*|"ubuntu 22"*|"ubuntu 24"*|"ubuntu 25"*)
      RSYSLOG_FILE="/etc/rsyslog.d/50-default.conf"
      ;;
    *)
      echo "⚠️ Sistem operasi $os_version tidak dikenali. Menggunakan default: /etc/rsyslog.conf"
      RSYSLOG_FILE="/etc/rsyslog.conf"
      ;;
  esac

  LOG_FILES=(
    "/var/log/auth.log"
    "/var/log/kern.log"
    "/var/log/mail.log"
    "/var/log/user.log"
    "/var/log/cron.log"
    "/var/log/user.log"
  )

  # pastikan file log ada
  for log_file in "${LOG_FILES[@]}"; do
    touch "$log_file"
  done

  set_permissions() {
    for log_file in "${LOG_FILES[@]}"; do
      if [[ -f "$log_file" ]]; then
        chmod 640 "$log_file"
        chown syslog:adm "$log_file"
      fi
    done
  }

  # cek apakah konfigurasi dropbear sudah ada
  check_dropbear_log() {
    grep -q 'if \$programname == "dropbear"' "$RSYSLOG_FILE"
  }

  # tambah konfigurasi dropbear
  add_dropbear_log() {
    echo "Menambahkan konfigurasi Dropbear ke $RSYSLOG_FILE..."
    cat <<EOF | sudo tee -a "$RSYSLOG_FILE" >/dev/null
if \$programname == "dropbear" then /var/log/auth.log
& stop
EOF
    systemctl restart rsyslog
    echo "✅ Konfigurasi Dropbear ditambahkan dan Rsyslog direstart."
  }

  if check_dropbear_log; then
    echo "ℹ️ Konfigurasi Dropbear sudah ada, tidak ada perubahan yang dilakukan."
  else
    add_dropbear_log
  fi

  set_permissions
}

# ==========================================
# Function: instal
# Deskripsi: Proses instalasi dan konfigurasi semua layanan
# ==========================================
function RUN() {
    clear
    PROXY_SETUP            # Inisialisasi pertama
    TOOLS_SETUP            # Instalasi paket dasar
    FODER_SETUP            # Membuat folder untuk Xray
    DOMAIN_MENU           # Menyetel domain
    SSL_SETUP              # Memasang SSL
    XRAY_SETUP             # Instalasi Xray core
    PW_DEFAULT             # Instalasi SSH dan dependensi
    LIMIT_HANDLER          # Instalasi Limit ip quota
   # SLOWDNS_SETUP          # SSH SlowDNS
    SSHD_SETUP             # Konfigurasi SSHD
    DROPBEAR_SETUP         # Instalasi Dropbear
    vnSTATS_SETUP          # Monitoring bandwidth
    OPVPN_SETUP            # OpenVPN
    RCLONE_SETUP           # Auto Backup system
    SWAPRAM_SETUP          # Instalasi Swap & Autoreboot
    FAIL2BAN_SETUP         # Proteksi brute-force login
    WEBSOCKET_SETUP        # Custom script tambahan
    RESTART_SERVICE        # Restart semua layanan
    MENU_SETUP             # Pasang menu CLI
    BASHRC_PROFILE         # Update environment profile    
    ENABLED_SERVICE        # Aktifkan semua service
    REBUILD_INSTALL
    SET_DETEK_SSH
    ADD_CEEF   
}

# ==========================================
# Eksekusi Instalasi
# ==========================================
RUN
echo ""

# ==========================================
# Pembersihan Jejak Instalasi
# ==========================================
history -c
echo "unset HISTFILE" >> /etc/profile

rm -rf /root/menu
rm -rf /root/*.zip
rm -rf /root/*.sh
rm -rf /root/LICENSE
rm -rf /root/README.md
rm -rf /root/domain
rm -rf /root/dropbear*
rm -rf /root/udp

clear
echo -e "\033[31;1m ============================ \033[0m"
echo -e "\033[92;1m FIX haproxy.cfg \033[0m"
echo -e "\033[31;1m ============================ \033[0m"

cat > /etc/haproxy/haproxy.cfg <<-EOF
# Author : Dian Permana ( Lunatic Tunneling )
# Add : Bandung Barat , saguling , Indonesia
global
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 1d
    tune.h2.initial-window-size 2147483647
    tune.ssl.default-dh-param 2048
    chroot /var/lib/haproxy
    user haproxy
    group haproxy
    daemon
    ssl-default-bind-options no-sslv3 no-tlsv10 no-tlsv11
    ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256
    ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384
    ca-base /etc/ssl/certs
    crt-base /etc/ssl/private

defaults
    log global
    mode tcp
    option dontlognull
    timeout connect 60s
    timeout client  300s
    timeout server  300s

# FRONTEND HTTP (80/8080)
frontend http_frontend
    mode tcp
    bind *:80 tfo
    bind *:8080 tfo
    bind *:8880 tfo
    bind *:2082 tfo
    tcp-request inspect-delay 5s
    tcp-request content accept if HTTP

    acl is_websocket hdr(Upgrade) -i websocket
    acl is_ovpn dst_port 1194
    acl is_grpc ssl_fc_alpn -i h2

    # DETEKSI PATH UNTUK XRAY
    acl is_vless path_beg -i /vless
    acl is_vmess path_beg -i /vmess
    acl is_trojan path_beg -i /trojan-ws

    use_backend vless_ws_backend if is_websocket is_vless
    use_backend vmess_ws_backend if is_websocket is_vmess
    use_backend trojan_ws_backend if is_websocket is_trojan

    use_backend grpc_backend if is_grpc
    use_backend ovpn_backend if is_ovpn

    # DEFAULT: WS SSH
    use_backend ws_backend if is_websocket
    default_backend dropbear_backend

# FRONTEND HTTPS (443)
frontend https_frontend
    bind *:443 ssl crt /etc/haproxy/hap.pem tfo
    mode tcp

    tcp-request inspect-delay 5s
    tcp-request content accept if { req.ssl_hello_type 1 }

    acl is_websocket_ssl hdr(Upgrade) -i websocket
    acl is_grpc ssl_fc_alpn -i h2

    acl is_vless path_beg -i /vless
    acl is_vmess path_beg -i /vmess
    acl is_trojan path_beg -i /trojan-ws

# VLESS
    use_backend vless_ws_backend if is_websocket_ssl is_vless
# VMESS
    use_backend vmess_ws_backend if is_websocket_ssl is_vmess
# TROJAN
    use_backend trojan_ws_backend if is_websocket_ssl is_trojan

    use_backend grpc_backend if is_grpc
    use_backend ws_backend if is_websocket_ssl
    default_backend dropbear_backend

# BACKEND SSH (Dropbear)
backend dropbear_backend
    mode tcp
    server dropbear_server 127.0.0.1:143 check

# BACKEND SSH WebSocket (ws.py)
backend ws_backend
    mode tcp
    server ssh_ws_server 127.0.0.1:10015 check

# BACKEND OPENVPN
backend ovpn_backend
    mode tcp
    balance roundrobin
    server p_ovpn 127.0.0.1:1194 check
    server l_ovpn 127.0.0.1:1012 send-proxy check

# BACKEND WEBSOCKET: VLESS
backend vless_ws_backend
    mode tcp
    server vless_ws 127.0.0.1:10001 check

# BACKEND WEBSOCKET: VMESS
backend vmess_ws_backend
    mode tcp
    server vmess_ws 127.0.0.1:10002 check

# BACKEND WEBSOCKET: TROJAN
backend trojan_ws_backend
    mode tcp
    server trojan_ws 127.0.0.1:10003 check

# BACKEND GRPC
backend grpc_backend
    mode tcp
    balance roundrobin
    server grpc_vless 127.0.0.1:10005 send-proxy check
    server grpc_vmess 127.0.0.1:10006 send-proxy check
    server grpc_trojan 127.0.0.1:10007 send-proxy check    
EOF

systemctl daemon-reload
systemctl enable haproxy
systemctl restart haproxy

function installer_udp() {
    wget ${LUNAREP}udp/ziv && chmod +x ziv && ./ziv
    wget ${LUNAREP}udp/udc && chmod +x udc && ./udc  
    }

echo "KANGGACOR" > /etc/xray/username
clear
echo ""    
echo -e "\033[95;1m INSTALL UDP CUSTOM & ZIVPN \033[0m"    
installer_udp
    
clear
echo -e "${YELLOW} INSTALL SELESAI ${NC}"
echo -e " tunggu 3 detik menuju reboot... "
sleep 3
reboot
