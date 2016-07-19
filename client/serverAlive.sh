#!/bin/bash

#include config-file
source config.sh

#Check if server is alive
#return: true: Server is alive; false: Server is offline
function alive {
	local SERVER_ALIVE_STRING=$(curl -X POST -F "MAC=$HW_MAC" -F "CPU=$HW_CPU" -F "VGA=$HW_VGA" $SRV"/"$SRV_ALIVE -s > /dev/null)

	if [ "$SERVER_ALIVE_STRING" = "true" ]
	then
		echo "true"
	else
		echo "false"
	fi
}

#####################
# Single-File-Check #
#####################

#Send data to server via POST
echo "Sending request to server..."

#Output is server alive?
if [ "$(alive)" = "true" ]
then
	echo "Request successfull. Server is alive."
else
	echo "Request failed, server might be offline."
fi
