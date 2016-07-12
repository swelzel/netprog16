#!/bin/bash
#URL of the server
SERVER_URL=$1

#Find the MAC adress
MAC_ADRESS=$(cat /sys/class/net/eth0/address)
#Find the CPU info
CPU=$(cat /proc/cpuinfo | grep model\ name | sort -u | cut -c 14-200)
#Find the VGA info
VGA=$(lspci | grep VGA | cut -c 36-200)


#Send data to server via POST
echo "Sending request to server..."
SERVER_ALIVE_STRING=$(curl -X POST -F "MAC=$MAC_ADRESS" -F "CPU=$CPU" -F "VGA=$VGA" $SERVER_URL -s > /dev/null)

if [ "$SERVER_ALIVE_STRING" = "true" ]
then
	echo "Request successfull. Server is alive."
else
	echo "Request failed, server might be offline."
fi

#echo $MAC_ADRESS
#echo $CPU
#echo $VGA


