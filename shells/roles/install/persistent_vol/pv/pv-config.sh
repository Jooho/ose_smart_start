. ../../../../config/ose_config.sh

#Definition
#VOL_SIZE - The size of pv volume
#PV_NAME_PREFIX - This is for pv name (refer following example)
#PV_NAME_PAD - This is pad for volume name (refer following example)
#PV_RANGE_START - The first number of pv volume (refer following example)
#PV_RANGE_END - The last number of pv volume (refer following example)
#PV_SCRIPT_PATH - The folder that will have pv scripts
#NFS_MOUNT_PATH - NFS mount point
#NFS_SERVER - NFS Server hostname

# Example - pv name
#  Suppose you want to create pv0001 to pv0012
#     PV_NAME_PREFIX should be pv
#     PV_NAME_PAD should be 0000
#     PV_RANGE_START should be 1
#     PV_RANGE_END should be 12


export VOL_SIZE="10Gi"
export PV_NAME_PREFIX=pv
export PV_NAME_PAD=0000 # pv0001
export PV_RANGE_START=1
export PV_RANGE_END=1
export PV_SCRIPT_PATH=./test_pv_script
export PVC_ACCESS_MODE=ReadWriteMany
export PVC_SCRIPT_PATH=./test_pvc_script

#For lvm name (Properties are from ../nfs/nfs-config.sh but you can overwrite it)
#export LVM_NAME_SIZE_PAD=000
#export NFS_SERVER_TAG=infra
#export LVM_NAME_PREFIX=pv
export LVM_VOL_SIZE=$(echo ${VOL_SIZE} |sed 's/[^0-9]*//g')
