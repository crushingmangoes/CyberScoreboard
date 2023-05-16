#!/bin/bash

#Remote Desktop Vulnerability scan WINDOWS Metasploitable3

#Parameters
#Script ip_address

#Make Sure The Correct Arguments are passed
if [ $# -ne 1 ]
then
	echo "Usage: $0 <host_ip>"
	exit 1
fi

#Save all the arguments in variables
IP_ADDR=$1

#Check for the required utilities
#Check if the metasploit framework is available
if ! command -v msfconsole &> /dev/null; then
    echo "This module requires msfconsole to be installed."
    exit 1
fi


#Export the variables so they can be taken in by Metasploit
export IP_ADDR



#Run the RC Script
command msfconsole -r rdp.rc $1 &> ./log 

#Check if the script contains a successful exploit
if grep -q "target is vulnerable" log;
then 
	exit 1
else 
	exit 0
fi

