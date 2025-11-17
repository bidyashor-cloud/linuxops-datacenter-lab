# Disk Capacity Troubleshooting

When I simulated a disk-full issue, I used these steps to find what was consuming space and fix it.

## 1. Checking Disk Usage
df -h

Then I checked which folders used the most space:

du -sh /var/* | sort -h

## 2. What I Found
Logs were taking up most of the disk space.

## 3. Fixing the Issue
I cleared large logs:

sudo truncate -s 0 /var/log/syslog
sudo truncate -s 0 /var/log/sample-service.log

If temp files were large:

sudo rm -rf /tmp/*

## 4. Prevention
- Set up log rotation.
- Health-check script monitors disk usage.
- Documented RCA in rcas/disk-full-rca.md.
