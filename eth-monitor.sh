#!/bin/sh
LOG=/opt/eth-monitor/logs/eth-monitor.`date +%F`.log

#sleep 12 seconds as loggin rate has reducedOD
sleep 12
echo `date` starting montinor execution...>>$LOG

upSec=`cat /proc/uptime | cut -d'.' -f1`
if [ $upSec -gt "1800" ]; then
	numEthMiners=`ps ax | grep ethminer | grep -v grep | wc -l`
	if [ "0" -eq $numEthMiners ]; then
        	echo restart condition: number of miners=$numEthMiners>>$LOG
		sudo shutdown -r now
	fi

	#not the best way
	numGPU=`lshw -C display | grep vendor | grep -v Intel | wc -l`
	if [ $numEthMiners -ne $numGPU ]; then
        	echo minestop condition: miners=$numEthMiners -ne GPUs=$numGPU>>$LOG
		ps ax | grep ethminer | grep -v grep | rev | cut -d' ' -f1>>$LOG
		#Come back to this once it is posible to detect that eth-miner is starting
		#/opt/ethos/bin/minestop
		sudo shutdown -r now
	else
		#inside loop, test each log file to detect if stuck
		echo looping ...>>$LOG
		for i in `seq 0 $(($numGPU-1))`; do
			now=`date +%M`
			lastRun=`tail -n 1 /var/run/miner.$i.output | cut -d: -f2`
        		delta=$(($now-$lastRun))
			#considering cron scheduling and lshw permormance, condition bellow ought to be enought		
			if [ "0" -ne $delta ]; then
                echo Restart condition detected for miner $i, detail: $lastRun $now $delta>>$LOG
				sudo shutdown -r now
        	fi
		done
		numNVIDIA=`nvidia-smi -L | wc -l`
		echo loop nvidia ...>>$LOG
		for j in `seq 0 $(($numNVIDIA-1))`; do
			tuple=`nvidia-smi -i $j -q -d POWER | grep -E "(Avg|Enforced)" | cut -d':' -f2 | cut -d'.' -f1`
			enforced=`echo $tuple | cut -d' ' -f1`
			average=`echo $tuple | cut -d' ' -f2`
			diff=$(($enforced-$average))
			if [ $diff -gt "7" ]; then
				#7 is arbitrary picked as tolerance
				echo Miner restart condition detected for miner $j, details: $enforced $average $diff>>$LOG
				/opt/ethos/bin/minestop
				/opt/ethos/bin/minestart
			fi
		done
		
	fi
fi

echo `date` monitor completed>>$LOG


