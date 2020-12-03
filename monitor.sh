#!/bin/bash

# Get container number
ct_num=$1

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

while read a
do
	 # Monitor for login event
	 accepted_line=$(echo "$a" | grep "sshd" | grep "Accepted password for")
	 if [ ! -z "$accepted_line" ]; then
		 # Extract IP address
		 ip_addr=$(tail -n1 /root/MITM_data/logins/${ct_num}.txt | cut -d';' -f2)
		 echo "New connection from $ip_addr"

		 echo "Attacker IP: $ip_addr" >> /root/MITM_log/mitm${ct_num}log_$2.txt
		 
		 # Extract attacker user name
		 name=$(tail -n1 MITM_data/login_attempts/${ct_num}.txt | cut -d';' -f4)
		 echo "User login from $name"

		 # Create file structure and Put the PII files in
		 if [ $name == "root" ]; then
			 path="/var/lib/lxc/$ct_num/rootfs/root/"
		 else
			 path="/var/lib/lxc/$ct_num/rootfs/home/$name/"
		 fi
		 /root/filestruct.sh $path

		 # Allow only the attacker in the container
		 iptables --table filter --insert INPUT 1 --protocol tcp --source $ip_addr --destination 172.20.0.1 --destination-port $port_num --jump ACCEPT
		 iptables --table filter --insert INPUT 2 --protocol tcp --source 0.0.0.0/0 --destination 172.20.0.1 --destination-port $port_num --jump DROP

		 # Execute wait script
		 /root/wait.sh $ct_num $ip_addr $2 &
		 exit
	 fi
done
