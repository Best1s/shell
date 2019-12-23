#!/bin/sh
function menu { 
clear
echo
echo -e "\t\t\tSys Admin Menu\n"
echo -e "\t1. Display disk space"
echo -e "\t2. Display logged on users"
echo -e "\t3. Display memory usage"
echo -e "\t0 or q. Exit menu\n\n"
#echo -en "\t\tEnter option: "
echo -en "\tEnter option: " 
read -n 1 option
}

function diskspace {
 clear
 echo "This is where the diskspace commands will go"
 df -h
}
function whoseon {
 clear
 who
}
function memusage {
 clear
 cat /proc/meminfo
}
while [ 1 ]
do
	menu
	case $option in
	0|q)
	 break ;;
	1)
	 diskspace ;;
	2)
	 whoseon ;;
	3)
	 memusage ;;
	*)
	 clear
	 echo "Sorry, wrong selection";;
	esac
	echo -en "\n\n\tHit any key to continue"
	read -n 1 line
done
clear
