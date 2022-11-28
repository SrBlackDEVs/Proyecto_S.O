#!/bin/bash 

service=$(systemctl is-active mysql)	

request=$1

	# Active MySQL service
	if [[ $service == 'inactive' ]];
	then
		echo -e '\e[1;28mActivating MySQL service'
		service mysql start
		
		if [[ $(systemctl is-active mysql) == 'active' ]];
		then
			echo -e '\e[1;32m+-----------------------------+'
			echo -e '\e[0;32m|   MySQL service activated   |'
			echo -e '\e[1;32m+-----------------------------+'
			echo -e '\e[0;0m' 
			clear
		fi
	fi


if [ "$1" == "login" ]
then
	echo -n "CI for login: "
	read ci
	echo -n "Pass for login: "
	read -s passU
	requestType="select typeUsr as '' from login where ci=$ci;"
	requestUser="select na as '' from login where ci=$ci;"
	requestPass="select pass as '' from login where ci=$ci;"


	
	clear
	
	type=$(mysql --user=root --password=srblack --ssl=false -h localhost SODB -e "$requestType")
	type="${type#"${type%%[![:space:]]*}"}"

	usr=$(mysql --user=root --password=srblack --ssl=false -h localhost SODB -e "$requestUser")
	usr="${usr#"${usr%%[![:space:]]*}"}"

	pass=$(mysql --user=root --password=srblack --ssl=false -h localhost SODB -e "$requestPass")
	pass="${pass#"${pass%%[![:space:]]*}"}"

	if [ -z $type ] || [ -z $usr ] || [ -z $pass ]
	then
	echo "That user doesn't exists"
	
	else 
		if [ $pass == "$passU" ] 
		then
			echo -e "User $(whoami) logged at $(date) and do \n -CHANGES- \n Logged into $usr"  >> ../Logs/SESSION_$(date +'%d_%m_%Y').txt || 2> /dev/null
			echo -e "\e[1;32mWelcome, $usr!"
			echo ty=$type >> ../Trash/.trashdb.txt
			echo usr=$usr >> ../Trash/.trashdb.txt
		else
			echo "Incorrect password. Try again"
			exit
		fi
	fi 2> /dev/null
	
else 
	value=$(mysql --user=root --password=srblack --ssl=false -h localhost SODB -e "$request")
	value="${value#"${value%%[![:space:]]*}"}"
	echo $value
	
fi


