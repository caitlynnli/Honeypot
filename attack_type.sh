#!/bin/bash
perl=()
pkill=()
wget=()
cloud=()
scp=()
uname=()
rmbot=()
system=()
curl=()
nproc=()
cpu=()
exit_cmd=()
nc=()
hist=()
type_1=()
type_2=()
type_3=()
type_4=()
#cpu=($(echo "${cpu[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
#uniques=($(for v in "${cpu[@]}"; do echo "$v";done| sort| uniq| xargs))
#for i in ${cpu[@]} ; do
#	echo "$i"
#done

echo_cmd=()

while IFS= read -r line; do
	#echo "start reading"
	ip="${line:8}"
	if [ ! -z "$ip" ]; then
		#echo $ip	
		while IFS= read -r line; do
			#for file in /root/MITM_log/* ; do
			ipexist=$(cat $line | grep $ip)
				#echo $ipexist
				#echo $not_found
			if [ ! -z "$ipexist" ] ; then
				#echo $ip
				cmds=$(cat $line | grep "Noninteractive mode attacker command")
				if [ ! -z "$cmds" ]; then
					content=$(cat $line | grep "Noninteractive mode attacker command" | cut -d':' -f4 | tr ';' '\n' | sort | uniq -c)
				fi
			
				if [ ! -z "$content" ]; then
					echo $content
					#hascmd=$($content | grep "scp")
					if [[ $content =~ .*"wget" ]] ; then
						type_3+=($ip)
					fi
					if [[ $content =~ .*"perl" ]] ; then
						type_3+=($ip)
					fi
					if [[ $content =~ .*"pkill" ]] ; then
						type_4+=($ip)
					fi
					if [[ $content =~ .*"scp" ]] ; then
						type_1+=($ip)
					fi
					if [[ $content =~ .*"/ip cloud print" ]] ; then
						type_1+=($ip)
					fi
					if [[ $content =~ .*"rm -rf bot.pl" ]] ; then
						type_4+=($ip)
					fi
					if [[ $content =~ .*"uname" ]] ; then
						type_2+=($ip)
					fi
					if [[ $content =~ .*"cpu" ]] ; then
						type_2+=($ip)
					fi
					if [[ $content =~ .*"curl" ]] ; then
						type_3+=($ip)
					fi
					if [[ $content =~ .*"system" ]] ; then
						type_3+=($ip)
					fi
					if [[ $content =~ .*"echo" ]] ; then
						type_1+=($ip)
					fi
					if [[ $content =~ .*"nproc" ]] ; then
						type_1+=($ip)
					fi
					if [[ $content =~ .*"release" ]] ; then
						type_2+=($ip)
					fi
					if [[ $content =~ .*"nc" ]] ; then
						type_1+=($ip)
					fi
					if [[ $content =~ .*"HISTFILE" ]] ; then
						type_1+=($ip)
					fi
					if [[ $content =~ .*"rm -f *sh" ]] ; then
						type_4+=($ip)
					fi
	
					#ct_log=$(( ct_log + 1 ))
				#	cmds1=$(cat $file | grep "line from reader")
				#	cmds2=$(cat $file | grep "Noninteractive mode attacker command")
				#	cmds3=$(cat $file | grep "Attacker authenticated and is inside container")
				#	if [ ! -z "$cmds1" ]; then
				#		ct_human=$(( ct_human + 1 ))	
				#		echo "Check human attacker: $file"
				#		#cat $file | grep "line from reader"
				#	fi
#
#					if [ ! -z "$cmds2" ]; then
#						ct_bot=$(( ct_bot + 1 ))
#					fi				
#					
#					if [ -z "$cmds1" ] && [ -z "$cmds2" ]; then
#						ct_empty=$(( ct_empty + 1 ))
#					fi
#					
#					# count number of authenticated attackers
#
#					if [ ! -z "$cmds3" ]; then
#						authenticated_attacker_count=$(( authenticated_attacker_count + 1 ))
#						ct_auth=$(( ct_auth + 1 ))
#					fi
#					
#				break;
				fi
			fi
		done < bot_logs.txt
	fi
done < bot_ips.txt
echo "Attacks that get our informatiion regarding our backend stuff" >> cmd_type.txt

type_1=($(echo "${type_1[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
for i in ${type_1[@]} ; do
	echo "$i" >> cmd_type.txt
done

echo "Attacks that get information regarding our hardware" >> cmd_type.txt
type_2=($(echo "${type_2[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
for i in ${type_2[@]} ; do
	echo "$i" >> cmd_type.txt
done

echo "Attacks that add somethign to our container" >> cmd_type.txt
type_3=($(echo "${type_3[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
for i in ${type_3[@]} ; do
	echo "$i" >> cmd_type.txt
done

echo "Attacks that remove something from our container" >> cmd_type.txt

type_4=($(echo "${type_4[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
for i in ${type_4[@]} ; do
	echo "$i" >> cmd_type.txt
done


#echo "Attacks that used cloud command" >> cmd_type.txt
#cloud=($(echo "${cloud[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
#for i in ${cloud[@]} ; do
#	echo "$i" >> cmd_type.txt
#done

#echo "Attacks that used scp command" >> cmd_type.txt
#scp=($(echo "${scp[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
#for i in ${scp[@]} ; do
#	echo "$i" >> cmd_type.txt
#done

#echo "Attacks that used uname command" >> cmd_type.txt
#uname=($(echo "${uname[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
#for i in ${uname[@]} ; do
#	echo "$i" >> cmd_type.txt
#done

#echo "Attacks that used rmbot command" >> cmd_type.txt
#rmbot=($(echo "${rmbot[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
#for i in ${rmbot[@]} ; do
#	echo "$i" >> cmd_type.txt
#done

#for file in /root/MITM_log/*; do
#	cmds=$(cat $file | grep "line from reader")
#	if [ ! -z "$cmds" ]; then 
#		echo $file
#		content=$(cat $file | grep "line from reader" | cut -d':' -f4 | sort | uniq -c)
#		ip=$(cat $file | grep 'Attacker IP Address: ' | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
#		echo "IP: $ip"	
#		#echo "/ip cloud print"
#		#type=$($content | grep "/ip cloud print")
#		#if [ ! -z "$type" ]; then
#		#	echo $ip
#		#fi
#
#	fi
#
#	#cmds=$(cat $file | grep "Noninteractive mode attacker command")
#	#if [ ! -z "$cmds" ]; then
#	#	echo $file
#	#	cat $file | grep "Noninteractive mode attacker command" | cut -d':' -f4 | tr ';' '\n' | sort | uniq -c
#	#fi
	
#done

