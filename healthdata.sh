#!/bin/bash

date > /root/healthlogoutput.txt
#CPU
free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }' >> /root/healthlogoutput.txt

#disk space
df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}' >> /root/healthlogoutput.txt
#system load
top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}' >> /root/healthlogoutput.txt
#network traffic
/sbin/ifconfig enp4s1 | grep "RX packets" | cut -d'(' -f2 | cut -d')' -f1 >> /root/healthlogoutput.txt
/sbin/ifconfig enp4s1 | grep "TX packets" | cut -d'(' -f2 | cut -d')' -f1 >> /root/healthlogoutput.txt

#container 1
#CPU
/usr/sbin/pct exec 201 -- free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }' >> /root/healthlogoutput.txt
#disk space
/usr/sbin/pct exec 201 -- df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}' >> /root/healthlogoutput.txt
#system load
/usr/sbin/pct exec 201 -- top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}' >> /root/healthlogoutput.txt
#network traffic
/sbin/ifconfig vmbr0 | grep "RX packets" | cut -d'(' -f2 | cut -d')' -f1 >> /root/healthlogoutput.txt
/sbin/ifconfig vmbr0 | grep "TX packets" | cut -d'(' -f2 | cut -d')' -f1 >> /root/healthlogoutput.txt

#container 2
#CPU
/usr/sbin/pct exec 202 -- free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }' >> /root/healthlogoutput.txt
#disk space
/usr/sbin/pct exec 202 -- df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}' >> /root/healthlogoutput.txt
#system load
/usr/sbin/pct exec 202 -- top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}' >> /root/healthlogoutput.txt
#network traffic
/sbin/ifconfig vmbr0 | grep "RX packets" | cut -d'(' -f2 | cut -d')' -f1 >> /root/healthlogoutput.txt
/sbin/ifconfig vmbr0 | grep "TX packets" | cut -d'(' -f2 | cut -d')' -f1 >> /root/healthlogoutput.txt

#container 3
#CPU
/usr/sbin/pct exec 203 -- free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }' >> /root/healthlogoutput.txt
#disk space
/usr/sbin/pct exec 203 -- df -h | awk '$NF=="/"{printf "%d/%dGB (%s)\n", $3,$2,$5}' >> /root/healthlogoutput.txt
#system load
/usr/sbin/pct exec 203 -- top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}' >> /root/healthlogoutput.txt
#network traffic
/sbin/ifconfig vmbr0 | grep "RX packets" | cut -d'(' -f2 | cut -d')' -f1 >> /root/healthlogoutput.txt
/sbin/ifconfig vmbr0 | grep "TX packets" | cut -d'(' -f2 | cut -d')' -f1 >> /root/healthlogoutput.txt

tail -n 21 /root/healthlogoutput.txt > /root/outputrow.txt

