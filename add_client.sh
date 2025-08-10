#!/bin/bash
set -euo pipefail

# usage: ./add_client.sh clientname

NAME="$1"
if [ -z "$NAME" ]; then
  echo "Usage: $0 client_name"
  exit 1
fi

WG_CONF="/etc/wireguard/wg0.conf"
OUT_DIR="/root"

# Ensure server public key exists
if [ ! -f /etc/wireguard/server_public.key ]; then
  echo "Server public key not found at /etc/wireguard/server_public.key"
  exit 1
fi

SERVER_PUBLIC=$(cat /etc/wireguard/server_public.key)
SERVER_IP_PLACEHOLDER="PLACEHOLDER_SERVER_PUBLIC_IP" # Заменить на публичный IP

# Generate client keys
CLIENT_PRIV=$(wg genkey)
CLIENT_PUB=$(echo "$CLIENT_PRIV" | wg pubkey)

# Find next IP in 10.0.0.x
LAST=$(grep -oP '10\.0\.0\.\K[0-9]+' "$WG_CONF" 2>/dev/null | sort -n | tail -n1 || true)
if [ -z "$LAST" ]; then
  LAST=1
fi
NEXT=$((LAST+1))
CLIENT_IP="10.0.0.${NEXT}"

# Append peer to server config
cat >> "$WG_CONF" <<EOF

[Peer]
PublicKey = $CLIENT_PUB
AllowedIPs = ${CLIENT_IP}/32
EOF

# Create client config file
cat > "${OUT_DIR}/${NAME}.conf" <<EOF
[Interface]
PrivateKey = $CLIENT_PRIV
Address = ${CLIENT_IP}/24
DNS = 1.1.1.1

[Peer]
PublicKey = $SERVER_PUBLIC
Endpoint = ${SERVER_IP_PLACEHOLDER}:51820
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
EOF

# Restart interface
systemctl restart wg-quick@wg0

chmod 600 "${OUT_DIR}/${NAME}.conf"

echo "Created ${OUT_DIR}/${NAME}.conf"