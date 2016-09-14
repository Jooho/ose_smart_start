#Definition
<<<<<<< HEAD
#PV_NAME_PREFIX - This is for pv name (refer following example)
#PV_SCRIPT_PATH - The folder that will have pv scripts
#PV_ACCESS_MODE - labels to match a PV and a PVC.(ReadWriteMany,ReadWriteOnly)
#PV_RECLAIM_POLICY - A volume reclaim policy (Recycle,Retain)
#PVC_NAME_PREFIX - This is for pvc name (refer following example)
#PVC_SCRIPT_PATH - The folder that will have pvc scripts
#PVC_ACCESS_MODE - ReadWriteManay or ReadWriteOnly

# Example - pv name
#  Suppose you want to create pv-infra-ose002g0001 to pv-infra-ose002g0012
#     PV_NAME_PREFIX should be pv
#     NFS_SERVER_TAG should infra  (nfs_config.sh)
#     PV_NAME_PAD should be 0000
#     LVM_RANGE_START should be 1  (nfs_config.sh)
#     LVM_RANGE_END should be 12   (nfs_config.sh)


export PV_NAME_PREFIX=pv
export PV_SCRIPT_PATH=./test_pv_script
export PV_ACCESS_MODE=ReadWriteMany
export PV_RECLAIM_POLICY=Recycle
=======
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


export VOL_SIZE="5Gi"
export PV_NAME_PREFIX=pv
export PV_NAME_PAD=0000 # pv0001
export PV_RANGE_START=1
export PV_RANGE_END=3
export PV_SCRIPT_PATH=./test_pv_script
>>>>>>> 43988bd5590e1d39e87ad520628990f0ede52ae3
export PVC_NAME_PREFIX=pvc
export PVC_ACCESS_MODE=ReadWriteMany
export PVC_SCRIPT_PATH=./test_pvc_script

#For lvm name (Properties are from ../nfs/nfs-config.sh but you can overwrite it)
#export LVM_NAME_SIZE_PAD=000
#export NFS_SERVER_TAG=infra
#export LVM_NAME_PREFIX=pv
#export LVM_VOL_SIZE=$(echo ${VOL_SIZE} |sed 's/[^0-9]*//g')
