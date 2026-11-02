#!/usr/bin/env bash
set -u

BASE_URL="https://127.0.0.1"
HTTP_URL="http://127.0.0.1"

echo "=== 1. Редирект 80 -> 443 (HTTP 301) ==="
curl -s -k -I -H "Host: app.local" "$HTTP_URL" | grep -E "HTTP/|Location"

echo -e "\n=== 2. Балансировка /api (чередование backend-1 и backend-2) ==="
for i in {1..4}; do
  curl -s -k -H "Host: app.local" "$BASE_URL/api/status"
  echo ""
  sleep 0.6
done

echo -e "\n=== 3. Проверка Basic Auth на /admin/ ==="
echo -n "Без пароля (401): "
curl -s -k -H "Host: app.local" -o /dev/null -w "%{http_code}\n" "$BASE_URL/admin/"
echo -n "С паролем (200): "
curl -s -k -H "Host: app.local" -u admin:secret -o /dev/null -w "%{http_code}\n" "$BASE_URL/admin/"

echo -e "\n=== 4. Проверка alias (/docs/) ==="
curl -s -k -H "Host: app.local" "$BASE_URL/docs/"

echo -e "\n=== 5. Проверка Rate Limit (должны появиться 429) ==="
for i in {1..7}; do
  status=$(curl -s -k -H "Host: app.local" -o /dev/null -w "%{http_code}" "$BASE_URL/api/status")
  echo "Запрос $i: HTTP $status"
done

echo -e "\n=== 6. Проверка виртуальных хостов ==="
echo -n "Host app.local: "
curl -s -k -H "Host: app.local" "$BASE_URL/"
echo -n "Host extra.local: "
curl -s -k -H "Host: extra.local" "$BASE_URL/"

echo -e "\n=== 7. Проверка кастомной 404 ==="
curl -s -k -H "Host: app.local" "$BASE_URL/non-existent-page"
