#!/bin/bash

path=$1

# level 1
mkdir $path/emails 
mkdir $path/passwords 
mkdir $path/names 
mkdir $path/empty

for dir in emails passwords names empty ; do
	# level 2
	mkdir $path/$dir/${dir}2_1
	mkdir $path/$dir/${dir}2_2
	mkdir $path/$dir/${dir}2_3

	i=1

	for d in $path/$dir/*/ ; do
		# level 3
		mkdir $path/$dir/${dir}2_$i/${dir}3_$(( 3*(i-1)+ 1 ))
		mkdir $path/$dir/${dir}2_$i/${dir}3_$(( 3*(i-1)+ 2 ))
		mkdir $path/$dir/${dir}2_$i/${dir}3_$(( 3*(i-1)+ 3 ))

		i=$(( i + 1 ))
	done
done

#Execute fakes.py to recreate and repopulate files
python3 ./fakes.py $path

touch $path/empty/empty2_1/empty3_2/empty.csv

