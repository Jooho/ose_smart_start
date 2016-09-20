Persistent Volume
--

This role has 2 different sub roles. **NFS sub modole has to be executed on NFS server* because normally there is firewall issue between ansible host and NFS. 
 
## NFS
###Configuration file
**${CONFIG_PATH}/nfs_config.sh**

~~~
# Example
#  Suppose you want to create ose0010g001 to ose0010g012
#     LVM_NAME_PREFIX should be ose
#     LVM_NAME_SIZE_PAD should be 0000
#     LVM_NAME_RANGE_PAD should be 000
#     LVM_RANGE_START should be 1
#     LVM_RANGE_END should be 12
#     LVM_VOL_SIZE should be 10  (without unit 'g')


export LVM_VOL_SIZE="2"
export LVM_NAME_PREFIX=ose
export LVM_NAME_SIZE_PAD=00 # 001
export LVM_NAME_RANGE_PAD=0000 # 0010
export LVM_RANGE_START=1
export LVM_RANGE_END=3
export NFS_MOUNT_POINT=/exports    #update
export NFS_VG_NAME=vg_ose            #update(required)
export NFS_LVM_BLOCK_DEV=          #update
export NFS_BLOCK_DEV=sda               #update
export NFS_SERVER="infra.example.com"  #update
export NFS_SERVER_TAG=infra
~~~

###SCRIPT
- **create_lvm_for_pv.sh**

With above configuration variables, this script will create following lvm:

**LVM :**

	/sda5/vg_ose/ose002g0001
	/sda5/vg_ose/ose002g0002
	/sda5/vg_ose/ose002g0003

**/etc/exports:**

	/exports/ose002g001  *(rw,root_squash,no_wdelay)
	/exports/ose002g002  *(rw,root_squash,no_wdelay)
	/exports/ose002g003  *(rw,root_squash,no_wdelay)


**/etc/fstab:**

	dev/vg_ose/ose002g0001 /exports/ose002g0001  xfs defaults 0 0
	dev/vg_ose/ose002g0002 /exports/ose002g0002  xfs defaults 0 0
	dev/vg_ose/ose002g0003 /exports/ose002g0003  xfs defaults 0 0

##PV

###Configuration
**${CONFIG_PATH}/pv_config.sh**

~~~
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
export PVC_NAME_PREFIX=pvc
export PVC_ACCESS_MODE=ReadWriteMany
export PVC_SCRIPT_PATH=./test_pvc_script
~~~

###SCRIPT
- **pv-openshift.sh**                
- **pvc-openshift.sh**

With above configuration variables, this script will create following pv/pvc:

**PV:**
	
	pv-infra-ose002g0001
	pv-infra-ose002g0002
	pv-infra-ose002g0003
  
**PVC:**

	pvc-infra-ose002g0001
	pvc-infra-ose002g0002
	pvc-infra-ose002g0003