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

MAC_ADDR=$(cat /sys/class/net/eth0/address)



echo "Searching for $PATH_CUSTOM_LIST"

if [ -e "$PATH_CUSTOM_LIST" ]
then
	echo "Found $PATH_CUSTOM_LIST"
else
	echo "Could not open $PATH_CUSTOM_LIST, make sure it exists and is valid."
	exit 1
fi


#UPDATE KERNEL vmlinuz
CLIENT_KERNEL_MD5=$(md5sum $PATH_KERNEL | cut -d ' ' -f1)
echo "Client KernelSum is: $CLIENT_KERNEL_MD5"
#make curl request here for server hash and replace if necessary
SERVER_KERNEL_MD5=$(curl --silent $SERVER_URL/S2C_AnswerKernel)
echo "Server KernelSum is: $SERVER_KERNEL_MD5"
#Some bash dialects have problems with == and =. Have to check for tinycore.
if [ "$CLIENT_KERNEL_MD5" = "$SERVER_KERNEL_MD5" ]
then
	echo "Client Kernel is up-to-date with Serverkernel."
else
	echo "Kernel-Hashsum mismatch with Server. Updating Client-Kernel now."
	#update client kernel here with wget, mv and so on....
fi




#UPDATE ROOT FILESYSTEM core.gz
CLIENT_COREGZ_MD5=$(md5sum $PATH_CORE)
echo "Client core.gz sum is: $CLIENT_CORE_GZ"
#make curl request for the core.gz
SERVER_COREGZ_MD5=$(curl --silent $SERVER_URL/S2C_AnswerCore)
echo "Server core.gz sum is: $SERVER_COREGZ_MD5"
if [ "$CLIENT_COREGZ_MD5" = "$SERVER_COREGZ_MD5" ]
then
	echo "Client core.gz is uptodate."
else
	echo "Core.gz-Hashsum mismatch with Server. Updating core,gz now."
fi


echo "Checking now for updates for custom cebitec apps."
#looping through file for custom cebitec apps and update them.
while read listItem
do
	echo "Checking Update for $listItem"
done <$PATH_CUSTOM_LIST









