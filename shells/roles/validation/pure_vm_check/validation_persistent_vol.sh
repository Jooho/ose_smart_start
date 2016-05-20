#!/bin/bash
#  
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.20
# Purpose: NFS Connectivity

. $CONFIG_PATH/ose_config.sh

echo "* Checking connectivity of NFS server($NFS_SERVER)"
connectivity_result=$(showmount -e $NFS_SERVER| grep -i "unknown host"| wc -l)

if [[ $connectivity_result != 0 ]]; then
  echo "$(hostname) is denied to access NFS server"
else
  echo "$(hostname) is allowed to access NFS server"
  echo ""

  # Mount nfs for testing
  echo "*Create folder 'test_NFS_MOUNT_POINT' "
  mkdir ./test_NFS_MOUNT_POINT 

  echo "*Mount test folder mount ${NFS_MOUNT_POINT} to ./test_NFS_MOUNT_POINT"
  mount -t nfs ${NFS_SERVER}:${NFS_MOUNT_POINT} ./test_NFS_MOUNT_POINT
  echo ""

  # Check if folder user is root
  user_group_test_result=$(ls -l ./test_NFS_MOUNT_POINT |grep "root root"| wc -l)
  if [[ ! ${user_group_test_result} -eq 1 ]]; then
    echo "===> **BAD!! user/group should be 'root'"
    ls -l ./test_NFS_MOUNT_POINT
  else
    echo "===> GOOD!! user/group of all folders under ${NFS_MOUNT_POINT} are 'root'"
  fi

  # Check if folder mode is 777
  execute_mode_test_result=$(ls -l ./test_NFS_MOUNT_POINT | grep  rwxrwxrwx| wc -l)
echo $execute_mode_test_result
  if [[ ! ${execute_mode_test_result} -eq  1 ]]; then
    echo "===> **BAD!! execute mode should be '0777'"
    ls -l ./test_NFS_MOUNT_POINT
  else
    echo "===> GOOD!! execute mode of all folders under ${NFS_MOUNT_POINT} are '0777'"
  fi


  echo ""
  echo "*Unmount test_NFS_MOUNT_POINT"
  umount ./test_NFS_MOUNT_POINT
  echo "*Delete test_NFS_MOUNT_POINT"
  rm -rf ./test_NFS_MOUNT_POINT

  echo ""
  echo "Check SELINUX"
  echo ""
  # SELINUX (setsebool -P virt_use_nfs 1)
  selinux_virt_use_nfs_result=$(getsebool virt_use_nfs|grep on|wc -l)
  selinux_virt_sandbox_use_nfs_result=$(getsebool virt_sandbox_use_nfs|grep on|wc -l)
  if [[ ${selinux_virt_use_nfs_result} != "1" ]]; then
    echo "===> BAD!! virt_use_nfs must be '1' (setsebool -P virt_use_nfs 1)"
    getsebool virt_use_nfs
  elif [[ ${selinux_virt_sandbox_use_nfs_result} != "1" ]]; then
    echo "===> BAD!! virt_sandbox_use_nfs must be '1' (setsebool -P virt_sandbox_use_nfs 1)"
    getsebool virt_sandbox_use_nfs
  else
    echo "===> GOOD!! virt_use_nfs is 1"
    echo "===> GOOD!! virt_sandbox_use_nfs is 1"
  fi
fi

echo ""
echo "------------------------------ "
if [[ $connectivity_result == 0  && ${user_group_test_result} == 2 && ${execute_mode_test_result} == 3 && ${selinux_virt_use_nfs_result} == "1" && ${selinux_virt_sandbox_use_nfs_result} == "1" ]];then
    echo "** Result >> PASS !!"
else
    echo "** Result >> FAIL ;("
fi
