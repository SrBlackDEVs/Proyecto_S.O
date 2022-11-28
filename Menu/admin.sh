#!/bin/bash 
option=10
bash ../Database/DBExec.sh login

cat ../Trash/.trashdb.txt > /dev/null 2> /dev/null # If the file doesnt exists close the script. Used for the incorrect passwords
if [ $? -eq 1 ]
then
	exit
fi

type=$(grep ty= ../Trash/.trashdb.txt | cut -d '=' -f2)
usr=$(grep usr= ../Trash/.trashdb.txt | cut -d '=' -f2)

rm -rf ../Trash/.trashdb.txt

function ErrorMessage () {
	echo -e "\e[0;31m+----------------------------------------------------------"
}

function waitKey() { # This is wait until a key will be pressed
	echo "Press enter to continue..."
	read IAmAUselessVariableLol > /dev/null 2> /dev/null
}

function showSpecial() {
		echo ""
		echo ""

		echo -e "\e[0;34m┌──(\e[1;37m$1\e[0;34m)-[\e[0;31mWarning, you are \e[1;31m$type\e[0;34m]"
		echo -e -n "└─\e[1;31m#\e[1;37m "
}
function user() {
	if [ $type != "Director" ]
	then
		echo "You don't have permissions to do this. You are not a director."
		waitKey
	else
		echo -e "                                                \e[0;35m+-----------------------------------------------------+"
		echo -e "                                                \e[0;35m|\e[1;34m              1: Add user                         \e[0;35m|"
		echo -e "                                                \e[0;35m|\e[1;34m              2: Delete an user                   \e[0;35m|"
		echo -e "                                                \e[0;35m+-----------------------------------------------------+"
		echo ""
		echo ""
		
		showSpecial "Type your option"
		
		read sub
		
		case $sub in
		
		1)
			showSpecial "CI of the new user "
			read ciUsr
			
			checkCI $ciUsr
			
			showSpecial  "Complete name of the user "
			read naUsr

			showSpecial "Password for the user"
			read -s password 
			
			if [ -z "$naUsr" ]
			then
				echo "Lol, a person who don't have name and surname."
				waitKey
			else
			
				if [ $valid -eq 1 ]
				then
					echo "Incorrect CI."
					waitKey
				else
					echo ""
					echo -e "                                                \e[0;35m+-----------------------------------------------------+"  
					echo -e "                                                \e[0;35m|\e[1;34m              1: Administrative 	               \e[0;35m|"
					echo -e "                                                \e[0;35m|\e[1;34m              2: Coordinator                         \e[0;35m|"
					echo -e "                                                \e[0;35m|\e[1;34m              3: Student advisor                     \e[0;35m|"
					echo -e "                                                \e[0;35m+-----------------------------------------------------+"
					
					showSpecial "Type of the new user"	
					read subsubop
					if [  $subsubop == "1" ]
					then
						newType="Administrativo"
					fi
					
					if [  $subsubop == "2" ] 
					then
						newType="Coordinador"
					fi
					
					if [  $subsubop == "3" ]
					then
						newType="Adscripto"
					fi
					if [ $subsubop != "1" ] && [ $subsubop != "2" ] && [ $subsubop != "3" ]
					then
						echo "Incorrect option."
						waitKey
					else
						DBExec "INSERT INTO login (ci, na, typeUsr, pass) VALUES ('$ciUsr', '$naUsr', '$newType', '$password');"
					fi 
				fi
			fi
		;;
		2)
			showSpecial "Type CI of the user to delete"
			read ci
			
			checkCI $ci
			
			if [ $valid -eq 0 ]
			then
				if [ ! -z $(DBExec "select ci as '' from login where ci='$ci';") ]
				then
					DBExec "delete from login where ci='$ci';"
					if [ -z $(DBExec "select ci as ''  from login where ci='$ci';") ]
					then
						echo "Deleted user with CI: $ci"
					else
					echo "Error deleting user"
					fi
				else 
				echo "That user doesn't exists"
				fi
			else
				echo "Incorret format to the CI"
			fi	
		
		;;
		esac
	fi
}

function showMenu() { # Show the menu with the design
	clear
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo ""
	echo -e "                                                \e[0;35m+-----------------------------------------------------+"
	echo -e "                                                \e[0;35m|\e[1;34m              1: Add or delete absence               \e[0;35m|"
	echo -e "                                                \e[0;35m|\e[1;34m              2: Show absences                       \e[0;35m|"
	echo -e "                                                \e[0;35m|\e[1;34m              3: User magnament                      \e[0;35m|"
	echo -e "                                                \e[0;35m|\e[1;34m              0: Close session                       \e[0;35m|"
	echo -e "                                                \e[0;35m+-----------------------------------------------------+"
	echo ""
	echo ""
	echo ""
	showSpecial "Logged as $usr"

}

function dateCalc() {
	fD=$(date +"%y/%m/%d" --date="+$1 day") 2> /dev/null # Calculate the date in a number of days
	
}

function addAbsence() { # This is to add an absence with a submenu
	echo -e "                                                \e[0;35m+-----------------------------------------------------+"
	echo -e "                                                \e[0;35m|\e[1;34m              1: Add absence        	               \e[0;35m|"
	echo -e "                                                \e[0;35m|\e[1;34m              2: Delete an absence                   \e[0;35m|"
	echo -e "                                                \e[0;35m+-----------------------------------------------------+"
	echo ""
	echo ""
	showSpecial "Select an option"
	read Subop
	
		case $Subop in
		1)
		showSpecial "CI of the teacher"
		read ciAdd
		checkCI $ciAdd
		
		if [ -z $(DBExec "select ci as '' from teacher where ci='$ciAdd';") ]
		then
			echo "Inexistent teacher"
		else
		

		if [ $valid == 1 ]
		then
			echo "Incorrect format for the CI. Try again."
			waitKey
		else
		
			showSpecial "Date of the absence (please use format YYYY/MM/DD)"
			read dateAdd
			dateAdd=$(checkDate $dateAdd)
		
		if [ $? != 0 ] 
		then
			echo "Format incorrect for the date. Try again"
		else
			showSpecial "It's more of a day? (S/N): "
			read day
			
			if [ $day != "S" ] && [ $day != "N" ] && [ $day != "s" ] && [ $day != "N" ]
			then
				echo "Only type S or N."
				waitKey
			else
				if [ $day == "S" ] || [ $day == "s" ]
				then
					showSpecial "Type quanty of days: "
					read qDays
					
					if [ -z $qDays ]
					then
						echo "Again, are you silly?"
						waitKey
					else
						dateCalc $qDays
						DBExec "INSERT INTO absences(init, final, ci) VALUES ('$dateAdd 00:00:00', '$fD 00:00:00', '$ciAdd');" > /dev/null
					fi
					
				else
					echo "Init hour of the absence (24H Format ex: 13:50): "
					read init			
					
					if [ ! $#init -ne 5 ] || [ ! $init =~ ":" ] || [ $(echo $init | cut -d ":" -f1) -ge 24 ] && [ $(echo $init | cut -d":" -f1) -le 00 ] || [ $(echo $init | cut -d":" -f2) -ge 60 ] && [ $(echo $init | cut -d":" -f2) -le -01 ] # Check hours
					then
						echo "Bad format for the date."
						echo "This is unbreakeable lol. Are you silly?"
						waitKey
					else
					
						echo "Final hour of the absence (24H format ex: 12:45): "
						read final
						
						if [ ! $#final -ne 5 ] || [ ! $final =~ ":" ] || [ $(echo $final | cut -d":" -f1) -ge 24 ] && [ $(echo $final | cut -d":" -f1) -le 00 ] || [ $(echo $final | cut -d":" -f2) -ge 60 ] && [ $(echo $final | cut -d":" -f2) -le -01 ]
						then
						
						echo "Bad format for the date."
						echo "This is unbreakeable lol. Are you silly?"
						waitKey
						
						else 
						echo "Please type the CI of the teacher: "
						read ciTeach
						checkCI $ciTeach
						
						if [ $valid -eq 0 ] || [ ! -z $(DBEXec "select na from teacher where ci="$ciTeach"") ]
						then
							DBExec "INSERT INTO absences(init, final) VALUES ('$(date +"%d %m %Y") $init:00'"> /dev/null
						else
							echo "Incorrect CI or teacher not found."
							echo "Why you continue trying to break my script?"
							waitKey
						fi						
				fi	
			fi
		fi
		fi
		fi
		fi
		fi # Without tab because I am stupid.
		;;
			
		2)
			showSpecial "CI of the teacher"
			read ciDel

			showSpecial "Date of the absence (please use format YYYY/MM/DD)"
			read dateDel
			dateDel=$(checkDate $dateDel)

			checkCI $ciDel

			if [ $valid -eq 0 ] && [ ! -z $dateDel]
			then
				DBExec "delete from absences where init=$dateDel"
			else
				echo "I am tired :(. I always need to handle exceptions. You are unbereable"
				waitKey
			fi


		;;
			
		*)
			echo "Incorrect option."
		;;
		esac
}


function DBExec() {
	val=$(../Database/DBExec.sh "$1")
	echo $val
}

function checkCI() {
	check=$(python2 checkCI.py $1)
	# CheckCI is a Python code that validate CIs ( I do that in Python because it isn't only for check only numbers and 8 digits, it verify all algorithms 
	if [ $check == "true" ]
	then
		valid=0
	else
		valid=1
	fi
}
function checkDate() {
	day=$(echo $1 | cut -d "/" -f3)
	month=$(echo $1 |cut -d "/" -f2)
	year=$(echo $1 | cut -d "/" -f1)

	date -d "$year-$month-$day" > /dev/null
	echo "$year-$month-$day"
	
}

function Exit() {
	echo "Thanks for use my program!"
}

while [ $option != 0 ]
do
	showMenu
	read option
	
	case $option in
	
	0)
	Exit
	;;
	
	2)
	abs=$(DBExec "select * from absences;")
	echo $abs
	;;
	
	1)
		addAbsence
	;;
		
	3)
		user
	;;
	
	*)
		echo "Incorrect option. Are you silly? lol"
		waitKey
	;;
		
	
	
	esac

done
