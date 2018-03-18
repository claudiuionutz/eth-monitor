# eth-monitor
Usage
Create crontab to schedule every 5 minutes: 
``` bash
*/5 * * * * /{location-tbd}/eth-monitor/eth-monitor.sh >> /{location-tbd}/eth-monitor.log 2>&1
```
Shouldn't run any more frequent as miners will take a few minutes to start. Maybe a restart condition should always be considered to avoid that. 

TODO:
1. Find suitable location (consider logging) 
2. Add looping logic
3. Consider logrotate
