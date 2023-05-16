#!/bin/bash

#WordPress vulnerability scanner
#This script is used to scan the host for the presence of Wordpress vulnerabilities
#Script runs a default credential scan on the target machine based on the username and passeword files provided.

#Parameters
#Script ip_address port_number user_file pass_file

#Make Sure The Correct Arguments are passed
if [ $# -ne 4 ]
then
	echo "Usage: $0 <host_ip> <port_no> <user_file> <pass_file>"
	exit 1
fi

#Save all the arguments in variables
IP_ADDR=$1
PORT_NO=$2
USER_FILE=$3
PASS_FILE=$4

#Check for the required utilities
#Check if the metasploit framework is available
if ! command -v msfconsole &> /dev/null; then
    echo "This module requires msfconsole to be installed."
    exit 1
fi


#Export the variables so they can be taken in by Metasploit
export IP_ADDR
export PORT_NO
export USER_FILE
export PASS_FILE



#Run Metasploit using the RC script
command msfconsole -r WordPress.rc &> ./log


#Check if the script contains a successful exploit
if grep -q -E "Success:" log;
then 
	exit 1
else 
	exit 0
fi
