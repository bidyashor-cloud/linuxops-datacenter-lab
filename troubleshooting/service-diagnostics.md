\# Service Diagnostics \& Troubleshooting



When I simulated a service failure, I used these steps to identify the issue and restore the service.



\## 1. Checking the Service

sudo systemctl status sample-service --no-pager



\## 2. What I Found

The service was not running. I checked logs:



sudo journalctl -u sample-service -n 50 --no-pager

tail -n 20 /var/log/sample-service.log



\## 3. Fixing the Issue

I corrected the permissions:



sudo chmod +x /opt/datacenter/scripts/sample-service.sh



Then I restarted the service:



sudo systemctl restart sample-service



\## 4. Prevention

\- Ensured script permissions were correct.

\- Added service checks in my health-check script.

\- Documented the RCA in rcas/service-failure-rca.md.



