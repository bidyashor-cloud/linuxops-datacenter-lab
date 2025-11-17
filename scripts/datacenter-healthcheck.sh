#!/bin/bash

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
LOGFILE="/var/log/datacenter-healthcheck.log"

SERVICES=("ssh" "sample-service")

CPU_THRESHOLD=85
MEM_THRESHOLD=90
DISK_THRESHOLD=90

echo "============================================" >> $LOGFILE
echo "Health Check Started: $TIMESTAMP" >> $LOGFILE
echo "============================================" >> $LOGFILE

CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)
echo "[CPU] Usage: ${CPU_USAGE}% (Threshold: ${CPU_THRESHOLD}%)" >> $LOGFILE
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "[CPU] ALERT: High CPU usage detected!" >> $LOGFILE
fi

MEM_USED_PERCENT=$(free | awk '/Mem/ {printf("%.0f", $3/$2 * 100)}')
echo "[MEMORY] Usage: ${MEM_USED_PERCENT}% (Threshold: ${MEM_THRESHOLD}%)" >> $LOGFILE
if [ "$MEM_USED_PERCENT" -ge "$MEM_THRESHOLD" ]; then
    echo "[MEMORY] ALERT: High memory usage detected!" >> $LOGFILE
fi

DISK_USED_PERCENT=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
echo "[DISK] / Usage: ${DISK_USED_PERCENT}% (Threshold: ${DISK_THRESHOLD}%)" >> $LOGFILE
if [ "$DISK_USED_PERCENT" -ge "$DISK_THRESHOLD" ]; then
    echo "[DISK] ALERT: Disk usage on / is high!" >> $LOGFILE
fi

echo "[SERVICES] Checking service status..." >> $LOGFILE
for service in "${SERVICES[@]}"; do
    if systemctl is-active --quiet $service; then
        echo "[SERVICE] OK: $service is running" >> $LOGFILE
    else
        echo "[SERVICE] ALERT: $service is NOT running" >> $LOGFILE
        systemctl status $service --no-pager >> $LOGFILE 2>&1
    fi
done

echo "[LOGS] Scanning logs for errors..." >> $LOGFILE
if [ -f /var/log/syslog ]; then
    grep -Ei "error|fail|critical" /var/log/syslog | tail -n 10 >> $LOGFILE
else
    journalctl -n 200 --no-pager | grep -Ei "error|fail|critical" | tail -n 10 >> $LOGFILE
fi

echo "Health Check Completed: $(date)" >> $LOGFILE
echo "" >> $LOGFILE
