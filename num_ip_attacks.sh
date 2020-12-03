#!/bin/bash

# all unique ips and number of times they attacked
cat unique_ips.txt | cut -d' ' -f3 | sort | uniq -c | sort -bgr > numattacks.txt
cat unique_ips.txt | cut -d' ' -f3 | sort | uniq | wc -l >> numattacks.txt

# unique bot ips
#cat all_unique_bot_ips.txt | cut -d' ' -f3 | sort | uniq -c | sort -bgr > bot_ips.txt
cat all_unique_bot_ips.txt | cut -d' ' -f3 | sort | uniq -c  > bot_ips.txt
tail -n +2 "bot_ips.txt"

echo Number of IPs: `cat bot_ips.txt | wc -l`
