#!/bin/bash

ct_num=$1

# Stop the exfiltration 
kill $(ps aux | grep "tail -n 0 -F /var/lib/lxc/$ct_num/rootfs/var/log/auth.log" | awk '{print $2}')

# Kill the MITM
kill $(ps aux | grep node | grep "mitm_$ct_num" | awk '{print  $2}')

sleep 10

# Unmount the container
pct unmount $ct_num

# Stop the container
pct unlock $ct_num
pct stop $ct_num --skiplock 1

# Unmount container again
# (it’s silly, but we need to do this because of pct’s inconsistency)
pct unmount $ct_num

# Destroy the container
pct destroy $ct_num

# Prepare template for cloning
pct unlock 200

# We want to repeatedly try the clone process until it succeeds
while ! pct clone 200 --hostname "CT$ct_num" $ct_num; do
	# Wait for 30 seconds before trying again
	sleep 30;
done

pct unlock 200

# Update networking configuration for container
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

if [ $ct_num -eq "201" ]; then
	pct set 201 --net0 name=eth0,bridge=vmbr0,ip=172.20.0.201/16,gw=172.20.0.1
elif [ $ct_num -eq "202" ]; then
	pct set 202 --net0 name=eth0,bridge=vmbr0,ip=172.20.0.202/16,gw=172.20.0.1
else
	pct set 203 --net0 name=eth0,bridge=vmbr0,ip=172.20.0.203/16,gw=172.20.0.1
fi

# Restart desired container
pct start $ct_num

# Mount the container
pct unlock $ct_num
rm -f /run/lock/lxc/pve-config-$ct_num.lock
pct mount $ct_num

echo "Recycled container $ct_num"

# Create file structure and Put the PII files in
# /root/filestruct.sh $ct_num $2

# Restart MITM
num=$(( $2 + 1 ))
nohup node /root/MITM/mitm/index.js HACS200_2G $port_num $ct_ip $ct_num true mitm_${ct_num}.js > /root/MITM_log/mitm${ct_num}log_$num.txt &

# Restart monitor script
nohup tail -n 0 -F /var/lib/lxc/$ct_num/rootfs/var/log/auth.log | ~/monitor.sh $ct_num $num &
exit

