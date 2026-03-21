# Decrypted by LT | FUSCATOR
# Github- https://github.com/LunaticTunnel/Absurd

chattr -i /etc/zivpn/api_auth.key
echo -e "Backup Data ZiVPN Old..."
[ -d /etc/zivpn-backup ] && rm -rf /etc/zivpn-backup
cp -r /etc/zivpn /etc/zivpn-backup

# hapus zivpn lama
rm -rf /etc/zivpn

set -euo pipefail
CACHE_DIR="/etc/zivpn"
IP_FILE="$CACHE_DIR/ip.txt"
ISP_FILE="$CACHE_DIR/isp.txt"
mkdir -p "$CACHE_DIR"
json="$(curl -4 -fsS --max-time 10 'https://ipwho.is/' 2>/dev/null || true)"
IP="$(printf '%s' "$json" | sed -nE 's/.*"ip"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' | head -n1)"
ISP="$(printf '%s' "$json" | sed -nE 's/.*"isp"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p' | head -n1)"
: "${IP:=N/A}"
: "${ISP:=N/A}"
tmp_ip="$(mktemp)"
tmp_isp="$(mktemp)"
printf '%s\n' "$IP"  > "$tmp_ip"
printf '%s\n' "$ISP" > "$tmp_isp"
mv "$tmp_ip"  "$IP_FILE"
mv "$tmp_isp" "$ISP_FILE"
chmod 644 "$IP_FILE" "$ISP_FILE"
echo "================================="
echo "IP  : $IP"
echo "ISP : $ISP"
echo "Saved:"
echo " - $IP_FILE"
echo " - $ISP_FILE"
echo "================================="
echo ""

echo -e "Restore Data ZiVPN Old..."
[ -d /etc/zivpn ] && rm -rf /etc/zivpn
cp -r /etc/zivpn-backup /etc/zivpn
systemctl restart zivpn zivpn
systemctl restart zivpn zivpn-api
chattr +i /etc/zivpn/api_auth.key
