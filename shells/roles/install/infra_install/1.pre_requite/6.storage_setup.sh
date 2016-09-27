#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.20
# Purpose: Each host have to have different lvm storage size and count according to a host role.
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160711   jooho  update
#
#
#

#  Information source
#      ETCD : ETCD db  - /var/lib/etcd 200G
#      Master : OSE Meta data - /var/lib/openshift  40%
#               Docker storage - sdb2   60%
#      Node : Docker storage - sdb2 100%
#   Execute Host:
#       All VMs
#    Question : why node does not have separated storage for OSE meta data             
##############################################################################

. $CONFIG_PATH/ose_config.sh

# Configure storage according to node role.
# ROUTINES FOR STORAGE
storage_etcd()
{
#######
# ETCD NODE
#######
echo "NOTE: Updating Storage on $HOST"
cat << EOF > do_storage.sh
#parted -s /dev/sdb mklabel gpt mkpart pri ext3 2048s 100% set 1 lvm on
pvcreate /dev/sdb1
vgcreate vg_ose /dev/sdb1
lvcreate -y -nlv_etcd -l100%FREE vg_ose
mkfs.xfs -f /dev/mapper/vg_ose-lv_etcd
mkdir /var/lib/etcd
echo "/dev/mapper/vg_ose-lv_etcd /var/lib/etcd xfs defaults 1 2" >> /etc/fstab
mount -a; restorecon -RFvv /var/lib/etcd
EOF
}

storage_compute() {
cat << EOF > do_storage.sh
echo "# Docker Storage Configuration" > /etc/sysconfig/docker-storage-setup
echo "DEVS=/dev/sdb" >> /etc/sysconfig/docker-storage-setup
echo "VG=docker-vg" >> /etc/sysconfig/docker-storage-setup
echo "SETUP_LVM_THIN_POOL=yes" >> /etc/sysconfig/docker-storage-setup
EOF
}

storage_master()
{
# OpenShift Storage followed by Docker
cat << EOF > do_storage.sh
#parted -s /dev/sdb mklabel gpt mkpart pri ext3 2048s 60% set 1 lvm on
pvcreate /dev/sdb1
vgcreate vg_ose /dev/sdb1
lvcreate -y -n lv_openshift -l50%FREE vg_ose
mkfs.xfs -f /dev/mapper/vg_ose-lv_openshift
echo "/dev/mapper/vg_ose-lv_openshift   /var/lib/openshift xfs defaults 1 2" >> /etc/fstab
mkdir /var/lib/openshift
mount -a; restorecon -RFvv /var/lib/openshift

# When etcd is installed on master servers, separate volume for etcd is needed
if [[ z${env} == z ]] || [[ $(${etcd_is_installed_on_master} == "true" ]]
then
     # START
     lvcreate -y -nlv_etcd -l100%FREE vg_ose
     mkfs.xfs -f /dev/mapper/vg_ose-lv_etcd
     echo "/dev/mapper/vg_ose-lv_etcd /var/lib/etcd xfs defaults 1 2" >> /etc/fstab
     mkdir /var/lib/etcd
     mount -a; restorecon -RFvv /var/lib/etcd
     # FINISH
fi

# Docker Storage
parted -s /dev/sdb mkpart pri ext3 60% 100%
echo "# Docker Storage Configuration" > /etc/sysconfig/docker-storage-setup
echo "VG=docker-vg" >> /etc/sysconfig/docker-storage-setup
pvcreate /dev/sdb2
vgcreate docker-vg /dev/sdb2
EOF
}


# CONFIGURE THE DEVICE DEPENDING ON WHAT HOST IT IS
for HOST in `grep -v \# ${host_file_path}/${host_file} | awk '{ print $1 }'`; 
do
  if [[ $HOST =~ $master_prefix ]]; then
      echo "NOTE: found $HOST"
      storage_master
  elif [[$HOST =~ $etcd_prefix ]]; then
      echo "NOTE: found $HOST"
      storage_etcd
  else
      echo "NOTE: found $HOST"
      storage_compute
  fi
  scp ./do_storage.sh root@$HOST:${ose_temp_dir}/${pre_requite_path}/
  ssh root@${HOST} "sh ${ose_temp_dir}/${pre_requite_path}/do_storage.sh"
done


