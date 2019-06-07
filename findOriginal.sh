#!/bin/bash
#
# This is a script that sorts data in a text file (data.txt) using GETOPTS
#
# Copyright (c) 2019, Matthew Chalifoux
#

if [ -z "$1" ]
then
	exit 1
fi

file_use=$(mktemp test19.XXX)
finalAdd=$(mktemp test19.XXX)

switch=0
storedN=0

exec 0< data.txt

while read line
do
	echo "$line" > $file_use
	while getopts 'f:l:e:n:' opt; do
		case $opt in
			f)	plp=$(awk '{print $1}' $file_use | egrep -w "\b$OPTARG\b");
				if [ ! -z "$plp" ]
				then	
					switch=1
				else
					cat /dev/null > $file_use
					break;
				fi;;
			l)	plp=$(awk '{print $2}' $file_use | egrep -w "\b$OPTARG\b");
				if [ ! -z "$plp" ]
				then
					switch=1
				else
					if [ $switch -eq 1 ]
					then
						cat /dev/null > $file_use
						break;
					fi 	
				fi;;
			e)	plp=$(awk '{print $3}' $file_use | egrep -w "\b$OPTARG\b");
				if [ ! -z "$plp" ]
				then	
					switch=1
				else
					if [ $switch -eq 1 ]
					then
						cat /dev/null > $file_use
						break;
					fi 
					if [ $switch -eq 0 ]
					then
						cat /dev/null > $file_use
					fi
				fi;;
			n)	storedN=$OPTARG;;				
			?)
		esac					
	done	
	cat $file_use >> $finalAdd
	unset opt OPTARG OPTIND
done 

exec 0>&-

if [ ! $storedN -eq 0 ]
then
	sort -k2,2 -k1,1  $finalAdd | head -$storedN 
else
	sort -k2,2 -k1,1  $finalAdd  
fi

rm -f $file_use 
rm -f $finalAdd
