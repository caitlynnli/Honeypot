#!/bin/bash

# Get the container number and IP address
ct_num=$1
ip_addr=$2

# Assign IP based on container number
if [ $ct_num -eq "201" ]; then
	ct_ip="172.20.0.201"
	port_num="10000"
elif [ $ct_num -eq "202" ]; then
	ct_ip="172.20.0.202"
	port_num="10001"
else
	ct_ip="172.20.0.203"
	port_num="10002"
fi

# Wait for specified amount of time (5 minutes)
echo "Started waiting for timeout on container $ct_num"
sleep 300

# Fix corrupt files
pct exec $ct_num -- killall sshd

# Check if empty
cmds1=$(cat /root/MITM_log/mitm${ct_num}log_$3.txt | grep "line from reader")
cmds2=$(cat /root/MITM_log/mitm${ct_num}log_$3.txt | grep "Noninteractive mode attacker command")
if [ -z "$cmds1" ] && [ -z "$cmds2" ]; then
	# Empty
	echo $ip_addr >> /root/attacker_ips.txt

	# Number of times empty
	num=$(cat /root/attacker_ips.txt | grep $ip_addr | wc -l)
	
	if [ $num -ge 3 ]; then
		# Permanently block attacker, after 3 empties
		iptables --table filter --insert INPUT 1 --source $ip_addr --destination 172.20.0.1 --jump
	fi
else
	# Permanently block attacker, if not empty
	iptables --table filter --insert INPUT 1 --source $ip_addr --destination 172.20.0.1 --jump DROP
fi


# Permanently block attacker
iptables --table filter --insert INPUT 1 --source $ip_addr --destination 172.20.0.1 --jump DROP

# Delete previously created rules
iptables --table filter --delete INPUT --protocol tcp --source $ip_addr --destination 172.20.0.1 --destination-port $port_num --jump ACCEPT
iptables --table filter --delete INPUT --protocol tcp --source 0.0.0.0/0 --destination 172.20.0.1 --destination-port $port_num --jump DROP

echo "Beginning recycle of $ct_num"
/root/recycle.sh $ct_num $3 &
exit

