Persistent Volume
---

##PV
This script create pv yaml file using configuration variables inside script.
###Configuration

	VOL_NAME=pv-infra-ose0500g0001
	LVM_VOL_SIZE=500
	PV_ACCESS_MODE=ReadWriteMany
	NFS_MOUNT_POINT=/exports
	LVM_VOL_NAME=lv_ose09
	NFS_SERVER=aoappd-e-nfs001.ctho.asbn.gtwy.dcn
	PV_RECLAIM_POLICY=Retain
	
###Usage
	create-pv-yaml.sh
	
===	
	
###PVC
This script create pvc yaml file using configuration variables inside script.
###Configuration
	VOL_NAME=ose09
	PVC_ACCESS_MODE=ReadWriteMany
	LVM_VOL_SIZE=500
	
###Usage
	create-pvc-yaml.sh
