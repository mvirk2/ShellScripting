# System Health Check Script (Bash)

This script monitors the health of a Linux system by checking:
- CPU usage
- Memory usage
- Disk space
- Network status
- Running services (e.g., Docker, MySQL, Nginx)

##  Features
- Logs output to a file (`/var/log/system_health.log`)
- Alerts for high CPU or memory usage
- Customizable list of services to monitor
- Can be automated via `cron`

## Technologies Used
- Bash (Shell Scripting)
- `top`, `free`, `df`, `awk`, `grep`, `systemctl`, `ping`

##  How to Use

1. Clone the repo:
```bash
git clone https://github.com/your-username/system-health-check.git
cd system-health-check
