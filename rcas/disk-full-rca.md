# RCA: Disk Full Incident

## Summary
The system experienced a disk-full condition during testing.

## Root Cause
Log files grew too large and filled the root partition.

## What I Did
- Cleared large logs.
- Removed temporary files.
- Verified disk usage returned to normal.

## Prevention
- Enabled log cleanup.
- Health-check script monitors disk usage.
