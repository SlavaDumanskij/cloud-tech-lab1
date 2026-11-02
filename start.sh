#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH=/data/data/com.termux/files/usr/bin:$PATH

chmod -R 755 "$DIR"
chmod 644 "$DIR/.htpasswd"

APP_INSTANCE_ID=backend-1 python "$DIR/main.py" 8001 > /dev/null 2>&1 &
echo $! > "$DIR/backend1.pid"

APP_INSTANCE_ID=backend-2 python "$DIR/main.py" 8002 > /dev/null 2>&1 &
echo $! > "$DIR/backend2.pid"

su -c "export PATH=/data/data/com.termux/files/usr/bin:\$PATH; nginx -p '$DIR' -c '$DIR/nginx.conf'"
echo "Сервисы запущены."
