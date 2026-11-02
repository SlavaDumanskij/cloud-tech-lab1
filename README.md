# Лабораторная работа 1: Nginx Load Balancer & Failover

## Запуск
```bash
./start.sh
./check.sh
./stop.sh
```

## Отказоустойчивость
```bash
kill -9 $(cat backend2.pid)
for i in {1..4}; do curl -s -k -H "Host: app.local" "https://127.0.0.1/api/status"; echo ""; sleep 0.6; done
```
