#!/bin/bash

#WebDAV vulnerability scanner
#This script is looking for risky methods such as PUT, DELETE, PUT, CONNECT, and TRACE

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


#Export the variables so they can be taken in by Nmap
export IP_ADDR



#Run the NMAP Script
command nmap -sV --script http-methods --script-args http-webdav-scan.path='/uploads/',http-methods.test-all -p8585 $1 &> ./webdav_log

#Check if the script contains a successful exploit
if grep -q "Potentially risky methods: DELETE PUT CONNECT TRACE" webdav_log;
then 
	exit 1
else 
	exit 0
fi

