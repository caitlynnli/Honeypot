#!/bin/bash

> bot_logs.txt

for file in /root/MITM_log/*; do
	cmds=$(cat $file | grep "line from reader")
	if [ ! -z "$cmds" ]; then 
		echo $file
		cat $file | grep "line from reader" | cut -d':' -f4 | sort | uniq -c
	fi

	cmds=$(cat $file | grep "Noninteractive mode attacker command")
	if [ ! -z "$cmds" ]; then
		echo $file
		echo "$file" >> bot_logs.txt  #put all bot logs in bot_logs.txt
		cat $file | grep "Noninteractive mode attacker command" | cut -d':' -f4 | tr ';' '\n' | sort | uniq -c
	fi
done

log_count=0
human_count=0
bot_count=0
empty_count=0
authenticated_attacker_count=0;

total_count=0
count1=0
count2=0
count3=0
for file in /root/MITM_data/sessions/* ; do
	month=$(sudo zcat $file 2> /dev/null | grep 'Date: 2020' | grep -o "2020-[0-9][0-9]-[0-9][0-9]" | cut -d'-' -f2)
	day=$(sudo zcat $file 2> /dev/null | grep 'Date: 2020' | grep -o "2020-[0-9][0-9]-[0-9][0-9]" | cut -d'-' -f3)

	if [ "$month" == "gzip: $file: unexpected end of file" ] || [ "$day" == "gzip: $file: unexpected end of file" ];  then
		continue
	fi

	if [ -z "$month" ] || [ -z "$day" ]; then
		continue
	fi

	#echo "${month}-${day}"
	if [ $month -eq 10 ] && [ $day -le 28 ]; then
		continue
	fi
	total_count=$(( total_count + 1 ))
	
	ct_num=$(sudo zcat $file 2> /dev/null | grep 'Container ID' | cut -d' ' -f3)
	if [ "$ct_num" == 201 ]; then
		count1=$(( count1 + 1 ))
	elif [ "$ct_num" == 202 ]; then
		count2=$(( count2 + 1 ))
	else 
		count3=$(( count3 + 1 ))
	fi
done

echo "Number of logs this week for container 201: $count1"
echo "Number of logs this week for container 202: $count2"
echo "Number of logs this week for container 203: $count3"
echo "Total logs this week: $total_count"
echo ""

for ct_num in 201 202 203 ; do
	ct_log=0
	ct_human=0
	ct_bot=0
	ct_empty=0
	ct_auth=0

	for file in /root/MITM_log/mitm$ct_num* ; do
		ct_log=$(( ct_log + 1 ))

		cmds1=$(cat $file | grep "line from reader")
		cmds2=$(cat $file | grep "Noninteractive mode attacker command")
		cmds3=$(cat $file | grep "Attacker authenticated and is inside container")
		if [ ! -z "$cmds1" ]; then
			ct_human=$(( ct_human + 1 ))
			#echo "Check: $file"
			#cat $file | grep "line from reader"
		fi
		if [ ! -z "$cmds2" ]; then
			ct_bot=$(( ct_bot + 1 ))
			#echo $file
			#cat $file | grep "Noninteractive mode attacker command"
		fi
		if [ -z "$cmds1" ] && [ -z "$cmds2" ]; then
			ct_empty=$(( ct_empty + 1 ))
		fi
	
		# count number of authenticated attackers
		if [ ! -z "$cmds3" ]; then
			authenticated_attacker_count=$(( authenticated_attacker_count + 1 ))
			ct_auth=$(( ct_auth + 1 ))
		fi
	done
	log_count=$(( log_count + ct_log ))
	human_count=$(( human_count + ct_human ))
	bot_count=$(( bot_count + ct_bot ))
	empty_count=$(( empty_count + ct_empty ))
	echo "Summary for container: $ct_num"
	echo "Number of logs: $ct_log"
	echo "Number of human attacks: $ct_human"
	echo "Number of bot attacks: $ct_bot"
	echo "Number of empty attacks: $ct_empty"
	#echo "Number of authenticated attackers: $ct_auth"
	echo ""
done

total=$(( human_count + bot_count ))
echo "Summary for all containers"
echo "Total number of logs: $log_count"
echo "Number of logs with either human or bot attacks: $total"
echo "Number of possible human attacks: $human_count"
echo "Number of possible bot attacks: $bot_count"
echo "Number of empty attacks: $empty_count"
echo "Total number of authenticated attackers: $authenticated_attacker_count"
echo ""

echo "Looking for that attacker"
for file in /root/MITM_data/sessions/* ; do
	line=$(sudo zcat $file 2> /dev/null | grep "fbsn-WVNdHuaE4uS!GT7mEJa")
			
	if [ "$line" == "gzip: $file: unexpected end of file" ]; then
		continue
	fi
	
	if [ ! -z "$line" ]; then
		echo $line
		ip=0
		ip=$(sudo zcat $file 2> /dev/null | grep 'Attacker IP Address: ' | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
		echo "IP: $ip"
	fi
done
echo "done"

exit 0

pii_found=0
for file in /root/MITM_log/* ; do
	cmds1=$(cat $file | grep "line from reader" | grep "emails")
	cmds2=$(cat $file | grep "line from reader" | grep "passwords")
	cmds3=$(cat $file | grep "line from reader" | grep "names")
	cmds4=$(cat $file | grep "line from reader" | grep "empty")	
	if [ ! -z "$cmds1" ] | [ ! -z "$cmds2" ] | [ ! -z "$cmds3" ] | [ ! -z "$cmds1" ]; then
		pii_found=$(( pii_found + 1 ))
		echo $file
	fi	
done
echo "PII accessed: $pii_found"

for num in 201 202 203 ; do 
	attack_count=0
	command_count=0
	for file in /root/MITM_log/mitm$num*.txt ; do
		attack_count=$(( attack_count + 1 ))

		cmds1=$(cat $file | grep "line from reader")
		cmds2=$(cat $file | grep "Noninteractive mode attacker command")
	
		if [ ! -z "$cmds1" ] | [ ! -z "$cmds2" ]; then
			command_count=$(( command_count + 1 ))
		fi
	done
	echo "Number of attack on $num with commands executed: $command_count"
	echo "Total number of attacks on $num: $attack_count"
done

