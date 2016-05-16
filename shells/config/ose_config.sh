# Essecial package : nfs-util

export password="redhat"
export all_hosts="master1.example.com master2.example.com master3.example.com node1.example.com node2.example.com node3.example.com node4.example.com node5.example.com lb.example.com "
export all_ip="192.168.200.100 192.168.200.101 192.168.200.102 192.168.200.104 192.168.200.105 192.168.200.106 192.168.200.107 192.168.200.108 192.168.200.108"
export node_prefix="node"
export master_prefix="master"
export etcd_prefix="etcd"
export infra_selector="region=infra"

export ansible_operation_vm="master1.example.com"
export etcd_is_installed_on_master="true"
export docker_log_max_file="3"
export docker_log_max_size="300m"
export docker_storage_dev="vda"
export docker_registry_route_url=registry.cloudapps.example.com

#docker image version
export image_version=v3.1.1.6
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
#  Suppose you want to create ose-infra-pv0010g001 to ose-infra-pv0010g012
#     LVM_NAME_PREFIX should be pv 
#     LVM_NAME_SIZE_PAD should be 0000
#     LVM_NAME_RANGE_PAD should be 000
#     LVM_RANGE_START should be 1
#     LVM_RANGE_END should be 12
#     LVM_VOL_SIZE should be 10  (without unit 'g')


export LVM_VOL_SIZE="10"
export LVM_NAME_PREFIX=pv
export LVM_NAME_SIZE_PAD=0000 # 001
export LVM_NAME_RANGE_PAD=000 # pv0010
export LVM_RANGE_START=1
export LVM_RANGE_END=1
export NFS_MOUNT_POINT=/exports/ose
export NFS_SERVER_TAG=infra
export NFS_BLOCK_DEV=sdb
export NFS_SERVER="infra.example.com"
