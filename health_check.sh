#!/bin/bash
# System Health Check Script
# Author: Rutuja Kurhekar

echo "===== System Health Check - $(date) ====="

# 1. Disk Check
disk_usage=$(df -h / | tail -1 | awk '{print $5}' | tr -d '%')
if [ $disk_usage -gt 80 ]; then
    echo "[DISK]   WARNING: Usage at ${disk_usage}%"
else
    echo "[DISK]   OK: Usage at ${disk_usage}%"
fi

# 2. Memory Check
mem=$(free -m | grep Mem | awk '{print $4}')
if [ $mem -lt 200 ]; then
    echo "[MEMORY] WARNING: Free memory ${mem}MB"
else
    echo "[MEMORY] OK: Free memory ${mem}MB"
fi

# 3. SSHD Process Check
if pgrep sshd > /dev/null 2>&1; then
    echo "[SSHD]   RUNNING"
else
    echo "[SSHD]   NOT RUNNING"
fi

# 4. Error Count in logs
log_file="/var/log/syslog"
if [ -f "$log_file" ]; then
    count=$(grep -ic "error" $log_file)
    echo "[ERRORS] Found $count error lines in syslog"
else
    echo "[ERRORS] Log file not found"
fi

echo "===== Check Complete ====="
