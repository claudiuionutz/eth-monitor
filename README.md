# eth-monitor
Usage
Create crontab to schedule every 5 minutes: */5 * * * * /{location-tbd}/eth-monitor/eth-monitor.sh

Shouldn't run any more frequent as miners will take a few minutes to start. Maybe a restart condition should always be considered to avoid that. 

TODO:
1. Fidn suitable location (consider logging)
2. Redirect output as well 
3. Add looping logic