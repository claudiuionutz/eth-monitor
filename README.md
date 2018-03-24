# eth-monitor
## 1. Purpose
Create an automated job that will restart the box once it determines that eth-miner is stuck.
## 2. Usage
So far there is no .rpm/package available so it needst to be manually installed.

  * Download and copy the eth-monitor.sh to a suitable location, like
  * Grant execution rights to eth-monitor.sh, 

``` bash
chmod +x eth-monitor.sh
```
  * Create crontab to schedule every 10 minutes: 

``` bash
*/10 * * * * /opt/eth-monitor/eth-monitor.sh >> /run/shm/eth-monitor.log 2>&1
```
Shouldn't run any more frequent as miners will take a few minutes to start. Maybe a restart condition should always be considered to avoid that. 

  * Optionally you can change log location

## 3. TODO:

  1. Find suitable location (consider logging) 
  2. Add looping logic
  3. Consider logrotate
