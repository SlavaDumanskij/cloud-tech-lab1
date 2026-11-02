#!/usr/bin/env bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
su -c "export PATH=/data/data/com.termux/files/usr/bin:\$PATH; killall nginx 2>/dev/null"
[ -f "$DIR/backend1.pid" ] && kill -9 $(cat "$DIR/backend1.pid") 2>/dev/null && rm -f "$DIR/backend1.pid"
[ -f "$DIR/backend2.pid" ] && kill -9 $(cat "$DIR/backend2.pid") 2>/dev/null && rm -f "$DIR/backend2.pid"
pkill -f "python.*main.py" 2>/dev/null
echo "Все сервисы остановлены."
