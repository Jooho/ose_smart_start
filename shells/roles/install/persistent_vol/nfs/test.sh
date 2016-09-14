
. $CONFIG_PATH/nfs_config.sh

for c in $(seq -f "%0${#LVM_NAME_RANGE_PAD}g" ${LVM_RANGE_START} ${LVM_RANGE_END})
do
   FORMATTED_LVM_SIZE=$(seq -f "%0${#LVM_NAME_SIZE_PAD}g" ${LVM_VOL_SIZE} ${LVM_VOL_SIZE})
   LVM_VOL_NAME="${LVM_NAME_PREFIX}${FORMATTED_LVM_SIZE}g$c"
#echo $FORMATTED_LVM_SIZE
echo $LVM_VOL_NAME
 #  check_lvm_exist=$(lvs |grep ${LVM_VOL_NAME}|wc -l)
 #  check_lvm_folder_exist=$(ls ${NFS_MOUNT_POINT}| grep ${LVM_VOL_NAME} |wc -l)

 #  if [[ $check_lvm_exist == 0 ]]; then
 #      lvcreate -n ${LVM_VOL_NAME} -L ${LVM_VOL_SIZE}G ${NFS_VG_NAME}
 #      mkfs.xfs /dev/${NFS_VG_NAME}/${LVM_VOL_NAME}
#
#       created_lvm=("${created_lvm[@]}" "${LVM_VOL_NAME}")
#   else
#       echo " ${LVM_VOL_NAME} exist"
#       exist_lvm=("${exist_lvm[@]}" "${LVM_VOL_NAME}")
#   fi
#
#   if [[ $check_lvm_folder_exist == 0 ]]; then
#       echo "create folder : ${NFS_MOUNT_POINT}/${LVM_VOL_NAME}"
#       mkdir -p ${NFS_MOUNT_POINT}/${LVM_VOL_NAME}
#       created_nfs_folder=("${created_nfs_folder[@]}" "${LVM_VOL_NAME}")
#       echo "/dev/${NFS_VG_NAME}/${LVM_VOL_NAME} ${NFS_MOUNT_POINT}/${LVM_VOL_NAME}  xfs defaults 0 0" >> /etc/fstab
#   else
#       echo "${NFS_MOUNT_POINT}/${LVM_VOL_NAME} exist"
#       exist_nfs_folder=("${exist_nfs_folder[@]}" "${LVM_VOL_NAME}")
##   fi

done
