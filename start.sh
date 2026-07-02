#!/bin/sh
set -eu

PORT="${PORT:-8080}"
VLESS_UUID="${VLESS_UUID:-ce9a67ec-d764-4a20-89c6-7670b4ff20c7}"
WS_PATH="${WS_PATH:-/}"

cat >/tmp/xray-config.json <<EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "tag": "railway-tm-vless-ws",
      "listen": "0.0.0.0",
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${VLESS_UUID}",
            "email": "turkmenistan-user",
            "flow": ""
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "${WS_PATH}"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF

echo "Starting Xray on 0.0.0.0:${PORT}, path=${WS_PATH}"
exec /usr/local/bin/xray run -config /tmp/xray-config.json
