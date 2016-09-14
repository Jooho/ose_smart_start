#This script is designed to execute on NFS server.


#Definition
#LVM_VOL_SIZE - The size of lvm volume (g)
#LVM_NAME_PREFIX - This is for lvm name (refer following example)
#LVM_NAME_PAD - This is pad for volume name (refer following example)
#LVM_RANGE_START - The first number of lvm volume (refer following example)
#LVM_RANGE_END - The last number of lvm volume (refer following example)
#NFS_MOUNT_PATH - NFS mount point
#NFS_SERVER_TAG - NFS server identification(infra, nfs1)
#NFS_BLOCK_DEV - NFS block device name for openshift pv

# Example
<<<<<<< HEAD
#  Suppose you want to create ose0010g001 to ose0010g012
#     LVM_NAME_PREFIX should be ose
=======
#  Suppose you want to create ose-infra-pv0010g001 to ose-infra-pv0010g012
#     LVM_NAME_PREFIX should be pv
>>>>>>> 43988bd5590e1d39e87ad520628990f0ede52ae3
#     LVM_NAME_SIZE_PAD should be 0000
#     LVM_NAME_RANGE_PAD should be 000
#     LVM_RANGE_START should be 1
#     LVM_RANGE_END should be 12
#     LVM_VOL_SIZE should be 10  (without unit 'g')


export LVM_VOL_SIZE="2"
export LVM_NAME_PREFIX=ose
export LVM_NAME_SIZE_PAD=00 # 001
export LVM_NAME_RANGE_PAD=0000 # pv0010
export LVM_RANGE_START=1
export LVM_RANGE_END=3
export NFS_MOUNT_POINT=/exports    #update 
export NFS_VG_NAME=vg_ose            #update(required)
export NFS_LVM_BLOCK_DEV=          #update
export NFS_BLOCK_DEV=sda               #update
export NFS_SERVER="infra.example.com"  #update
<<<<<<< HEAD
export NFS_SERVER_TAG=infra

=======
>>>>>>> 43988bd5590e1d39e87ad520628990f0ede52ae3
