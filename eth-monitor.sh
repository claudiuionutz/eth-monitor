#!/bin/sh
LOG=/tmp/eth-monitor/eth-monitor.`date +%F`.log

echo `date` starting montinor execution...>>$LOG

numEthMiners=`ps ax | grep ethminer | grep -v grep | wc -l`
if [ "0" -eq $numEthMiners ]; then
        echo restart condition: number of miners=$numEthMiners>>$LOG
#       sudo shutdown -r now
fi

#not the best way
numGPU=`lshw -C display | grep vendor | grep -v Intel | wc -l`
if [ $numEthMiners -ne $numGPU ]; then
        echo minestop condition: miners=$numEthMiners -ne GPUs=$numGPU>>$LOG
        /opt/ethos/bin/minestop
else
#inside loop, test each log file to detect if stuck
echo looping ...
fi

echo `date` monitor completed>>$LOG


