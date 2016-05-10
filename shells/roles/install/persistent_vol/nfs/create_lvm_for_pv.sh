. ../../../../config/ose_config.sh

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
   echo "Create pv : /dev/${NFS_BLOCK_DEV}5"
   pv_exist=$(sshpass -p $password ssh root@$NFS_SERVER "pvs|grep /dev/${NFS_BLOCK_DEV}5|wc -l")
   if [[ $pv_exist == "0" ]]; then
      echo "sshpass -p $password ssh root@$NFS_SERVER \"pvcreate /dev/${NFS_BLOCK_DEV}5\""
      sshpass -p $password ssh root@$NFS_SERVER "pvcreate /dev/${NFS_BLOCK_DEV}5"
   else
      echo "/dev/${NFS_BLOCK_DEV}5 exist"
   fi

   echo "Create vg : ose-${NFS_SERVER_TAG}-vg"
   vg_exist=$(sshpass -p $password ssh root@$NFS_SERVER "vgs|grep ose-${NFS_SERVER_TAG}-vg|wc -l")
   if [[ $vg_exist == 0 ]]; then
       sshpass -p $password ssh root@$NFS_SERVER "vgcreate -s 16M ose-${NFS_SERVER_TAG}-vg /dev/${NFS_BLOCK_DEV}5"   #(16M==> chunk size)
   else
       echo "ose-${NFS_SERVER_TAG}-vg exist"
   fi
fi


for c in $(seq -f "%0${#LVM_NAME_RANGE_PAD}g" ${LVM_RANGE_START} ${LVM_RANGE_END})
do
   FORMATTED_LVM_SIZE=$(seq -f "%0${#LVM_NAME_SIZE_PAD}g" ${LVM_VOL_SIZE} ${LVM_VOL_SIZE})
   LVM_VOL_NAME="ose-${NFS_SERVER_TAG}-${LVM_NAME_PREFIX}${FORMATTED_LVM_SIZE}g$c"

   check_lvm_exist=$(sshpass -p $password ssh root@$NFS_SERVER "lvs |grep ${LVM_VOL_NAME}|wc -l")
   check_lvm_folder_exist=$(sshpass -p $password ssh root@$NFS_SERVER "ls ${NFS_MOUNT_POINT}| grep ${LVM_VOL_NAME} |wc -l")
  
   if [[ $check_lvm_exist == 0 ]]; then
       sshpass -p $password ssh root@$NFS_SERVER "lvcreate -n ${LVM_VOL_NAME} -L ${LVM_VOL_SIZE}G ose-${NFS_SERVER_TAG}-vg"
       sshpass -p $password ssh root@$NFS_SERVER "mkfs.xfs /dev/ose-${NFS_SERVER_TAG}-vg/${LVM_VOL_NAME}"

       created_lvm=("${created_lvm[@]}" "${LVM_VOL_NAME}")
   else
       echo " ${LVM_VOL_NAME} exist"
       exist_lvm=("${exist_lvm[@]}" "${LVM_VOL_NAME}")
   fi
  
   if [[ $check_lvm_folder_exist == 0 ]]; then
       echo "create folder : ${NFS_MOUNT_POINT}/${LVM_VOL_NAME}"
      sshpass -p $password ssh root@$NFS_SERVER " mkdir -p ${NFS_MOUNT_POINT}/${LVM_VOL_NAME} "
       created_nfs_folder=("${created_nfs_folder[@]}" "${LVM_VOL_NAME}")
   else
       echo "${NFS_MOUNT_POINT}/${LVM_VOL_NAME} exist"
       exist_nfs_folder=("${exist_nfs_folder[@]}" "${LVM_VOL_NAME}")
   fi
  
   sshpass -p $password ssh root@$NFS_SERVER "echo \"/dev/ose-${NFS_SERVER_TAG}-vg/${LVM_VOL_NAME} ${NFS_MOUNT_POINT}/${LVM_VOL_NAME}  xfs defaults 0 0\" >> /etc/fstab"
done

echo ""
echo "Do you want to mount all?(y/n)"
read mount
if [[ $mount == y ]]; then
  sshpass -p $password ssh root@$NFS_SERVER " mount -a "
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

