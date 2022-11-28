#!/bin/bash

function ErrorMessage() {

	echo -e "+----------------------------------------------------------+"
	echo -e "|                      $1                                  |"
	echo -e "+----------------------------------------------------------+" # 58 -

	
	for i in "$#"
	do
		if [ ${i#}] then
			
		fi
	done
	
}
ErrorMessage "Hola" "Chau" "Soy gay" "Me la re como"
