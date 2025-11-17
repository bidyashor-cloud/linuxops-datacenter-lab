\# CPU Usage Troubleshooting



When I simulated a high-CPU issue in my Linux lab, I followed these steps to identify the problem and fix it.



\## 1. How I Detected the Issue

I checked the CPU usage:



top -b -n1 | head -n 10



Then I identified the top processes:



ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head -n 10



\## 2. What I Found

I found a process running in a loop and consuming a lot of CPU.



\## 3. How I Fixed It

I stopped the process:



sudo kill -9 <PID>



Then I verified the CPU load returned to normal:



top -b -n1 | head -n 10



\## 4. Prevention

\- I checked cron jobs for loops.

\- I added CPU alerts in my health-check script.

\- I documented the RCA in rcas/cpu-spike-rca.md.



