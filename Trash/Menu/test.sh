#!/bin/bash

function checkCI() {
	check=$(python2 checkCI.py $1)
	if [ $check == "true" ]
	then
		valid=0
	else
		valid=1
	fi
}
checkCI $1
echo $valid
