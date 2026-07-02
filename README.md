# Railway TM VLESS WS Server

Готовый минимальный сервер для Railway:

```text
Protocol: VLESS
Network: WebSocket
Railway public port: 443
Container listen: 0.0.0.0:$PORT
TLS: через Railway domain
Xray internal security: none
Path: /
```

## 1. Railway variables

В Railway открой сервис → Variables и добавь:

```text
VLESS_UUID=ce9a67ec-d764-4a20-89c6-7670b4ff20c7
WS_PATH=/
```

`PORT` вручную не добавляй. Railway сам выдаёт `PORT`, а контейнер слушает `0.0.0.0:$PORT`.

## 2. Deploy через Railway CLI

```bash
npm i -g @railway/cli
railway login
cd railway-tm-vless
railway init
railway up
```

После деплоя:

1. Открой сервис в Railway.
2. Settings → Networking → Public Networking.
3. Нажми `Generate Domain`.
4. Скопируй домен вида:

```text
your-service.up.railway.app
```

## 3. Готовый VLESS ключ

Замени `YOUR_RAILWAY_DOMAIN` на свой Railway-домен:

```text
vless://ce9a67ec-d764-4a20-89c6-7670b4ff20c7@YOUR_RAILWAY_DOMAIN:443?encryption=none&security=tls&type=ws&path=%2F&host=YOUR_RAILWAY_DOMAIN&sni=YOUR_RAILWAY_DOMAIN&fp=chrome&alpn=http%2F1.1#Turkmenistan-Railway-1
```

## 4. Настройки клиента вручную

```text
Address: YOUR_RAILWAY_DOMAIN
Port: 443
UUID: ce9a67ec-d764-4a20-89c6-7670b4ff20c7
Encryption: none
Security: tls
SNI: YOUR_RAILWAY_DOMAIN
Fingerprint: chrome
ALPN: http/1.1
Network: ws
Path: /
Host: YOUR_RAILWAY_DOMAIN
```

## 5. Проверка WebSocket

```bash
HOST=YOUR_RAILWAY_DOMAIN

curl -vk --http1.1 "https://$HOST/" \
  -H "Connection: Upgrade" \
  -H "Upgrade: websocket" \
  -H "Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==" \
  -H "Sec-WebSocket-Version: 13"
```

Хороший ответ:

```text
HTTP/1.1 101 Switching Protocols
```

## 6. Важно

Railway не является Google Cloud Run:

```text
Не будет run.app host.
Не будет Google frontend IP.
Не нужно ставить SNI www.google.com.
SNI и Host должны быть Railway-доменом.
```

Для стабильной работы лучше использовать свой домен через Cloudflare:

```text
tm1.yourdomain.com CNAME your-service.up.railway.app
```

Тогда ключ будет:

```text
vless://ce9a67ec-d764-4a20-89c6-7670b4ff20c7@tm1.yourdomain.com:443?encryption=none&security=tls&type=ws&path=%2F&host=tm1.yourdomain.com&sni=tm1.yourdomain.com&fp=chrome&alpn=http%2F1.1#Turkmenistan-Railway-1
```
