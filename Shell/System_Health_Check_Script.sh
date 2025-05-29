    #!/bin/bash
    set -euo pipefail # Exit on error, undefined variable, or pipe failure

    LOG_FILE ="/var/log/system_health.log
    DATE = $(date '+%Y-%m-%d %H:%M:%S')

    echo "=====System Health Check [$DATE]=====">> "$LOG_FILE"

    CPU_USAGE = $(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}') # Get CPU usage percentage , awk means print 2nd column and 4th column, grep means search for "Cpu(s)", -bn1 means batch mode, no header, and one iteration

    echo " CPU Usage : $CPU_USAGE%" >> "$LOG_FILE"

    MEM_USAGE = $(free -m | awk '/Mem:/ {printf("%.2f"), $3/$2 * 100}') # Get memory usage percentage, free -m means show memory in MB, awk means print 3rd column divided by 2nd column times 100

    echo " Memory Usage : $MEM_USAGE%" >> "$LOG_FILE"

    DISK_USAGE = $(df -h / | awk 'NR==2 {print $5}') # Get disk usage percentage, df -h means show disk usage in human-readable format, awk means print 5th column of the second row
    
    echo " Disk Usage : $DISK_USAGE%" >> "$LOG_FILE"
    
    SERVICES=("docker" "nginx" "mysql")
    for service in "${SERVICES[@]}; do 
      systemctl is-active --quiet "$service" && STATUS="Running" || STATUS="Not Running"
      echo "$service status: $STATUS" >> "$LOG_FILE"
    done     
    # SERVICES[@]  means all elements in the array, systemctl is-active --quiet means check if the service is active without outputting anything, && means if the previous command succeeded, then execute the next command, || means if the previous command failed, then execute the next command

     PING -C 2 8.8.8.8 &> /dev/null && echo "Network: Online" >> "$LOG_FILE" || echo "Network: offline" >> "$LOG_FILE" 
     # PING -C 2 means send 2 ICMP echo requests to the specified IP address, &> /dev/null means redirect both stdout and stderr to /dev/null, so no output is shown, && means if the previous command succeeded, then execute the next command, || means if the previous command failed, then execute the next command

     if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
         echo "Warning: High CPU usage detected! $CPU_USAGE%" | Tee -a "$LOG_FILE"
     fi

     if (( $(echo "$MEM_USAGE > 80" | bc -l) )); then
         echo "Warning: High Memory usage detected! $MEM_USAGE%" | Tee -a "$LOG_FILE"
     fi