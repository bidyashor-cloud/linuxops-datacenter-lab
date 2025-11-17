# RCA: CPU Spike Incident

## Summary
A test process caused the CPU usage to exceed normal levels.

## Root Cause
A looped process was running continuously and consuming CPU.

## What I Did
- Identified the PID.
- Terminated the process.
- Verified CPU returned to normal.

## Prevention
- Reviewed cron jobs.
- Added CPU alerts in health-check script.
