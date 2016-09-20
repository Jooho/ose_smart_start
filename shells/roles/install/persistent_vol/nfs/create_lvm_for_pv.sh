#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.08.03
# Purpose: This script create lvm on nfs for PV.
#
# History:
#          Date      |   Changes
#========================================================================
#        20160803        update
#        20160808        add /etc/exports 
#
#

. ${CONFIG_PATH}/ose_config.sh

export exist_lvm
export created_lvm
export created_nfs_folder
export exit_nfs_folder

#ose-${NFS_SERVER_TAG}-${LVM_NAME_PREFIX}
# FDISK new block device to LVM type.
echo "The block device '${NFS_BLOCK_DEV}' is LVM type?(y/n)"
read "block_dev_lvm_type"

echo ""
if [[ $block_dev_lvm_type == n ]]; then
cat << EOF
   You have to do fdisk by yourself!.

   Following is the way to fdisk:

   # fdisk -cu /dev/${NFS_BLOCK_DEV}
     =>  n
     =>  e (extended)
     => Enter, Enter , Enter  (means that it selects whole volume)
     => n
     => l
     => Enter , Enter  (means that it select whole volume)
     => t
     => 5  (partion number, which will be used for pvcreate)
     => 8e (hex code which stand for LVM)
     => w
EOF
exit 0

else
   if [[ z$NFS_LVM_BLOCK_DEV == z ]]; then
       NFS_LVM_BLOCK_DEV=${NFS_BLOCK_DEV}5
   fi

   echo "Create pv : /dev/${NFS_LVM_BLOCK_DEV}"
   pv_exist=$(pvs|grep /dev/${NFS_LVM_BLOCK_DEV}|wc -l)
   if [[ $pv_exist == "0" ]]; then
      echo "pvcreate /dev/${NFS_LVM_BLOCK_DEV}"
      pvcreate /dev/${NFS_LVM_BLOCK_DEV}
   else
      echo "/dev/${NFS_LVM_BLOCK_DEV} exist"
   fi

   echo "Create vg : ${NFS_VG_NAME}"
   vg_exist=$(vgs|grep ${NFS_VG_NAME}|wc -l)
   if [[ $vg_exist == 0 ]]; then
       vgcreate -s 16M ${NFS_VG_NAME} /dev/${NFS_LVM_BLOCK_DEV}   #(16M==> chunk size)
   else
      echo "${NFS_VG_NAME} exist"
   fi
    
fi


for c in $(seq -f "%0${#LVM_NAME_RANGE_PAD}g" ${LVM_RANGE_START} ${LVM_RANGE_END})
do
   FORMATTED_LVM_SIZE=$(seq -f "%0${#LVM_NAME_SIZE_PAD}g" ${LVM_VOL_SIZE} ${LVM_VOL_SIZE})
   LVM_VOL_NAME="${LVM_NAME_PREFIX}${FORMATTED_LVM_SIZE}g$c"

   check_lvm_exist=$(lvs |grep ${LVM_VOL_NAME}|wc -l)
   check_lvm_folder_exist=$(ls ${NFS_MOUNT_POINT}| grep ${LVM_VOL_NAME} |wc -l)
  
   if [[ $check_lvm_exist == 0 ]]; then
       lvcreate -n ${LVM_VOL_NAME} -L ${LVM_VOL_SIZE}G ${NFS_VG_NAME}
       mkfs.xfs /dev/${NFS_VG_NAME}/${LVM_VOL_NAME}

       created_lvm=("${created_lvm[@]}" "${LVM_VOL_NAME}")
   else
       echo " ${LVM_VOL_NAME} exist"
       exist_lvm=("${exist_lvm[@]}" "${LVM_VOL_NAME}")
   fi
  
   if [[ $check_lvm_folder_exist == 0 ]]; then
       echo "create folder : ${NFS_MOUNT_POINT}/${LVM_VOL_NAME}"
       mkdir -p ${NFS_MOUNT_POINT}/${LVM_VOL_NAME} 
       created_nfs_folder=("${created_nfs_folder[@]}" "${LVM_VOL_NAME}")
       echo "/dev/${NFS_VG_NAME}/${LVM_VOL_NAME} ${NFS_MOUNT_POINT}/${LVM_VOL_NAME}  xfs defaults 0 0" >> /etc/fstab
       echo "${NFS_MOUNT_POINT}/${LVM_VOL_NAME}  *(rw,root_squash,no_wdelay)" >> /etc/exports
       chmod 777 -R ${NFS_MOUNT_POINT} 
       chown nfsnobody.nfsnobody -R ${NFS_MOUNT_POINT}
   else
       echo "${NFS_MOUNT_POINT}/${LVM_VOL_NAME} exist"
       exist_nfs_folder=("${exist_nfs_folder[@]}" "${LVM_VOL_NAME}")
   fi
  
done

echo ""
echo "Do you want to mount all?(y/n)"
read mount
if [[ $mount == y ]]; then
  mount -a 
fi

echo ""
echo ""
echo "Summary :"
echo "=============================================================="
echo Exist lvm  :
echo ${exist_lvm[@]}
echo ""
echo Created lvm  :
echo ${created_lvm[@]}
echo ""
echo Exist nfs folder  :
echo ${exist_nfs_folder[@]}
echo ""
echo Created nfs folder  :
echo ${created_nfs_folder[@]}

