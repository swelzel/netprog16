#!/bin/bash

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

#Build DIR variables...
PATH_CUSTOM_LIST=$MOUNT_POINT/tce/cebitec_custom_tcz.txt
PATH_CUSTOM_PACKAGE=$MOUNT_POINT/tce/optional/
PATH_KERNEL=$MOUNT_POINT/tce/boot/vmlinuz
PATH_CORE=$MOUNT_POINT/tce/boot/core.gz
PATH_TMP=$MOUNT_POINT/tmp_downloads

MAC_ADDR=$(cat /sys/class/net/wlp3s0/address)

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
SERVER_KERNEL_RESPONSE=$(curl --silent -X POST -d "mac=$MAC_ADDR&hash=$CLIENT_KERNEL_MD5" $SERVER_URL/S2C_AnswerKernel)
echo "Server Kernelresponse is: $SERVER_KERNEL_RESPONSE"
#Some bash dialects have problems with == and =. Have to check for tinycore.
if [ $SERVER_KERNEL_RESPONSE = "True" ]
then
	echo "Client Kernel is up-to-date with Serverkernel."
elif [ $SERVER_KERNEL_RESPONSE = "False" ]
then
	echo "Kernel-Hashsum mismatch with Server. Updating Client-Kernel now."
	KERNEL_URL=$(curl --silent -X POST -d "mac=$MAC_ADDR" $SERVER_URL/S2C_SendKernel)
	if [ $? -ne 0 ]
	then
		echo "Could not get file location from server for the kernel, aborting."
		exit 1
	fi

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
SERVER_COREGZ_RESPONSE=$(curl --silent -X POST -d "mac=$MAC_ADDR" $SERVER_URL/S2C_AnswerCore)
echo "Server core.gz response is: $SERVER_COREGZ_RESPONSE"
if [ $SERVER_COREGZ_RESPONSE = "True" ]
then
	echo "Client core.gz is uptodate."
elif [ $SERVER_COREGZ_RESPONSE = "False" ]
then
	echo "Core.gz-Hashsum mismatch with Server. Updating core,gz now."
	COREGZ_URL=$(curl --silent -X POST -d "mac=$MAC_ADDR" $SERVER_URL/S2C_SendCore)
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









