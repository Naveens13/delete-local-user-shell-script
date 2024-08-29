#!/bin/bash

#Make sure the script is being executed with superuser privileges.
if [[ ${UID} = 0 ]]
then
	echo "Root user check completed....."
else
	echo "Need user access to continue....." >&2
	exit 1
fi


#Function - Usage statement
function usage() {
	echo "./disable-local-user.sh [OPTION]...[OPTION]...<ARG>..." >&2
	echo "OPTIONS:" >&2
	echo "-d Delete accounts instead of disabling them." >&2
	echo "-r Removes the home directory associated with the account(s)." >&2
	echo "-a Creates an archive of the home directory associated with the accounts(s) and stores the archive in the /archives directory. (NOTE: /archives is not a directory default on a Linux system. The script will need to create this directory if it does not exist.)" >&2
	exit 1
}

DIS_USR="true"

#Parse the options
#r - to delte accounts instead of disabling them.(True/false)
#d - to delete the user(True/false)
#a - to achive the user(True/false)

while getopts dra OPTION
do
	case ${OPTION} in
		d)
			DIS_USR="false"
			DEL_USR="true"
			echo "Deletion process started....."
			;;
		r)
			RM_DIR="true"
			echo "Removing home directory started......."
			;;
		a)
			AHV="true"
			echo "Creating a archive started........"
			;;
		?)
			echo "Please enter a valid input....." >&2
			usage
			;;
	esac
done

#Getting the username arguments
echo "Number of arguments ${OPTIND}"
shift $(( OPTIND -1 ))
echo "Other arg: ${@}"

#iterating into the arguments
while [[ ${#} > 0 ]]
do
	echo "Processing for- ${1}"
        #Disabling user and checking exit status 
	if [[ ${DIS_USR} = "true" ]]
	then
		echo "Disabling user started....."
		chage -E 0 ${1}
	fi

        if [[ ${?} = 0 ]]
	then
		echo "User disabled successfully...."
	else
		echo "Error occured in disabling user...."
		exit 1
	fi

	#Deleting user and checking the exit status
	if [[ ${DEL_USR} = "true" ]]
	then
		echo "user deletion started....."
		userdel ${1}
	fi

	if [[ ${?} = 0 ]]
	then
		echo "User deleted successfully...."
	else
		echo "Error occured in user deletion...."
		exit 1
	fi

	#Removing home directory and checking exit status
	if [[ ${RM_DIR} = "true" ]]
	then 
		echo "Deleting home directory......"
		userdel -r ${1}
	fi

	if [[ ${?} = 0 ]]
	then 
		echo "Home directory removed......"
	else
		echo "Error occured in removal of home directory......"
		exit 1
	fi

	#Archive directory and checking exit status
	if [[ ${AHV} = "true" ]]
	then
		echo "Archiving directory......."
		tar -cvf /backups/${1}.tar /home/${1}
	fi

	if [[ ${?} = 0 ]]
	then
		echo "Archiving completed....."
	else
		echo "Error occured ........"
		exit 1
	fi

	shift
done
