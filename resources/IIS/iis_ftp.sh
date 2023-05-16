#!/bin/bash

#IIS FTP vulnerability scanner
#This script is used to scan the host for the presence of IIS FTP vulnerabilities
#Default Credential Vulnerability is the target vulnerability in this script

#Parameters
#Script ip_address
#Username file
#Password fle

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


#Run Metasploit using the RC script
command msfconsole -r iis_ftp.rc &> ./log


#Check if the script contains a successful exploit
if grep -q -E "Login Successful" log;
then 
	exit 1
else 
	exit 0
fi

