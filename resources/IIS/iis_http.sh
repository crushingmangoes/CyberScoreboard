#!/bin/bash

#IIS HTTP vulnerability scanner
#Vulnerability - Remote Code Execution
#CVE_ID: CVE-2015-1635 
#This script is used to scan the host for the presence of IIS HTTP vulnerabilities

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



#Run Metasploit using the RC script
command msfconsole -r iis_http.rc &> ./log


#Check if the script contains a successful exploit
if grep -q -E "Memory dump saved to" log;
then 
	exit 1
else 
	exit 0
fi

