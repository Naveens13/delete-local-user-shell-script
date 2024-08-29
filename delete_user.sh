#!/bin/bash

#To conform if user is logged in as root
if [[ ${UID} != 0 ]]
then
	echo "User is not logged in as root......"
	exit 1
fi

#To get the username from the argument
if [[ ${#} = 0 ]]
then
        echo "Please pass atleast one argument......"
   	exit 1
fi

#To get the username and delete username
USERNAME=${1}
echo "Username to delete- ${USERNAME}"
userdel ${USERNAME}

#To get the exit status and error
if [[ ${?} != 0 ]]
then
	echo "Error occured while deleting user"
	exit 1
else
	echo "User deleted successfully......."
fi

exit 0
