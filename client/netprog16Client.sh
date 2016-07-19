#!/bin/bash

#Load config file
source config.sh

SERVER_URL=$1
MOUNT_POINT=$2

#echo Server is given with $SERVER_URL
#echo Mountpoint is given with $MOUNT_POINT

if [ -d $MOUNT_POINT ]
then
	echo $MOUNT_POINT is a valid directory.
else
	echo $MOUNT_POINT is not a valid directory...exiting.
	exit 1
fi

mkdir -p $PATH_TMP



echo "Searching for $PATH_CUSTOM_LIST"

if [ -e "$PATH_CUSTOM_LIST" ]
then
	echo "Found $PATH_CUSTOM_LIST"
else
	echo "Could not open $PATH_CUSTOM_LIST, make sure it exists and is valid."
	exit 1
fi

echo "---------------------------------------------------------------"


#UPDATE KERNEL vmlinuz
CLIENT_KERNEL_MD5=$(md5sum $PATH_KERNEL | cut -d ' ' -f1)
echo "Client KernelSum is: $CLIENT_KERNEL_MD5"
#make curl request here for server hash and replace if necessary
SERVER_KERNEL_RESPONSE=$(curl --silent -X POST -d "mac=$HW_MAC&hash=$CLIENT_KERNEL_MD5" $SERVER_URL/S2C_AnswerKernel)
echo "Server Kernelresponse is: $SERVER_KERNEL_RESPONSE"
#Some bash dialects have problems with == and =. Have to check for tinycore.
if [ $SERVER_KERNEL_RESPONSE = "True" ]
then
	echo "Client Kernel is up-to-date with Serverkernel."
elif [ $SERVER_KERNEL_RESPONSE = "False" ]
then
	echo "Kernel-Hashsum mismatch with Server. Updating Client-Kernel now."
	KERNEL_URL=$(curl --silent -X POST -d "mac=$HW_MAC" $SERVER_URL/S2C_SendKernel)
	if [ $? -ne 0 ]
	then
		echo "Could not get file location from server for the kernel, aborting."
		exit 1
	ficonfig.sh

	#update client kernel here with wget, mv and so on....
	wget --quiet -P $PATH_TMP $SERVER_URL/S2C_SendKernel/vmlinuz
	if [ $? -ne 0 ]
	then
		echo "Could not download vmlinuz from Server."
		exit 1
	fi
	mv -f $PATH_KERNEL $PATH_KERNEL.bak
	mv $PATH_TMP/vmlinuz $PATH_KERNEL
	echo "Succesfully updatet Kernel (backuped the old one with .bak in same location...)"

else
	echo "Could not get valid response from Server for the Kernel."
fi

echo "---------------------------------------------------------------"



#UPDATE ROOT FILESYSTEM core.gz
CLIENT_COREGZ_MD5=$(md5sum $PATH_CORE)
echo "Client core.gz sum is: $CLIENT_CORE_GZ"
#make curl request for the core.gz
SERVER_COREGZ_RESPONSE=$(curl --silent -X POST -d "mac=$HW_MAC" $SERVER_URL/S2C_AnswerCore)
echo "Server core.gz response is: $SERVER_COREGZ_RESPONSE"
if [ $SERVER_COREGZ_RESPONSE = "True" ]
then
	echo "Client core.gz is uptodate."
elif [ $SERVER_COREGZ_RESPONSE = "False" ]
then
	echo "Core.gz-Hashsum mismatch with Server. Updating core,gz now."
	COREGZ_URL=$(curl --silent -X POST -d "mac=$HW_MAC" $SERVER_URL/S2C_SendCore)
	if [ $? -ne 0 ]
	then
		echo "Could not get file location from server for the core filesystem, aborting."
		exit 1
	fi
	#update the core
	wget --quiet -P $PATH_TMP $SERVER_URL/S2C_SendCore/core.gz
	if [ $? -ne 0 ]
	then
		echo "Could not download core.gz from Server."
		exit 1
	fi
	mv -f $PATH_CORE $PATH_CORE/core.gz.bak
	mv $PATH_TMP/core.gz $PATH_CORE
	echo "Succesfully updatet core filesystem (backuped the old one with .bak in same location...)" 
	
else
	echo "Could not get valid responsfre from Server for the Core Filesystem."
fi


echo "---------------------------------------------------------------"

echo "Checking now for updates for custom cebitec apps."
#looping through file for custom cebitec apps and update them.
while read listItem
do
	echo "Checking Update for $listItem"
done <$PATH_CUSTOM_LIST



echo "Cleaning up temporary files..."
rm -rf $PATH_TMP


#Update kernel/ core/ package (Single
#call: update PACKAGE PATH API-ASK API-GET
#PACKAGE: "core.gz" = Update core, "vmlinuz" = update kernel, "package-name" = update package
#PATH: Path to local file
#API_ASK/ API_GET: API URL without $SRV
#return: true: update successfull, false: update fail, "null": no update available
#get return: echo $(update PACKAGE PATH API_ASK API_GET)
function update {
	PACKAGE=$1
	PATH=$2
	API_ASK=$3
	API_GET=$4

	MD5_SUM=$(md5sum $PATH | cut -d ' ' -f1)
	echo " MD5-SUM is: $MD5_SUM"
	#make curl request here for server hash and replace if necessary
	SERVER_RESPONSE=$(curl --silent -X POST -d "mac=$HW_MAC&hash=$MD5_SUM" $SRV/$API_ASK)
	echo "Server response is: $SERVER_RESPONSE"
	#Some bash dialects have problems with == and =. Have to check for tinycore.
	if [ $SERVER_RESPONSE = "True" ]
	then
		echo "Client Kernel is up-to-date with Serverkernel."
	elif [ $SERVER_RESPONSE = "False" ]
	then
		echo "Kernel-Hashsum mismatch with Server. Updating Client-Kernel now."
		URL=$(curl --silent -X POST -d "mac=$HW_MAC" $SRV/$API_GET)
		if [ $? -ne 0 ]
		then
			echo "Could not get file location from server for the kernel, aborting."
			exit 1
		fi

		#update client here with wget, mv and so on....
		wget --quiet -P $PATH_TMP $SRV/$API_GET/$PACKAGE
		if [ $? -ne 0 ]
		then
			echo "Could not download vmlinuz from Server."
			exit 1
		fi
		mv -f $PATH/$PACKAGE $PATH/$PACKAGE.bak
		mv $PATH_TMP/$PACKAGE $PATH/$PACKAGE
		echo "Succesfully updated (backuped the old one with .bak in same location...)"

	else
		echo "Could not get valid response from Server for the Kernel."
	fi

	echo "---------------------------------------------------------------"

	# Dummy return
	echo "null"
}






