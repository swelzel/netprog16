#!/bin/bash

#Server-URLS
SRV="http://posttestserver.com/post.php"
SRV_ALIVE=""
SRV_ASK_KERNEL="C2S_AskKernel"
SRV_ASK_CORE="C2S_AskCore"
SRV_ASK_PACKAGE="C2S_AskPackage"
SRV_ASK_URL_KERNEL="C2S_GetKernelURL"
SRV_ASK_URL_CORE="C2S_GetCoreURL"
SRV_ASK_URL_PACKAGE="C2S_GetPackageURL"
SRV_GET_KERNEL="S2C_AnswerKernel"
SRV_GET_CORE="S2C_AnswerCore"
SRV_GET_PACKAGE="S2C_AnswerPackage"
SRV_GET_URL_KERNEL="S2C_SendKernelURL"
SRV_GET_URL_CORE="S2C_SendCoreURL"
SRV_GET_URL_PACKAGE="S2C_SendPackageURL"

#Mount-Point
MOUNT_POINT=$2

#Hardware-Information
HW_MAC=$(cat /sys/class/net/eth0/address)
HW_CPU=$(cat /proc/cpuinfo | grep model\ name | sort -u | cut -c 14-200)
HW_VGA=$(lspci | grep VGA | cut -c 36-200)

#Build DIR variables...
PATH_CUSTOM_LIST=$MOUNT_POINT/tce/cebitec_custom_tcz.txt
PATH_CUSTOM_PACKAGE=$MOUNT_POINT/tce/optional/
PATH_KERNEL=$MOUNT_POINT/tce/boot/vmlinuz
PATH_CORE=$MOUNT_POINT/tce/boot/core.gz
PATH_TMP=$MOUNT_POINT/tmp_downloads
