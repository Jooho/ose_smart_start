# NFS Connectivity
. ../../ose_config.sh

echo "* Checking connectivity of NFS server($nfs_server)"
connectivity_result=$(showmount -e $nfs_server| grep -i "unknown host"| wc -l)

if [[ $connectivity_result != 0 ]]; then
  echo "$(hostname) is denied to access NFS server"
else
  echo "$(hostname) is allowed to access NFS server"

  echo ""
  # Mount nfs for testing
  echo "*Create folder 'test_nfs_mount_point' "
  mkdir ./test_nfs_mount_point 

  echo "*Mount test folder mount ${nfs_mount_point} to ./test_nfs_mount_point"
  mount -t nfs infra.example.com:${nfs_mount_point} ./test_nfs_mount_point
  # Check if folder user is root
  echo ""
  user_group_test_result=$(ls -al ./test_nfs_mount_point |grep -v root| wc -l)
  if [[ ${user_group_test_result} != "2" ]]; then
    echo "===> BAD!! user/group should be 'root'"
    ls -al ./test_nfs_mount_point
  else
    echo "===> GOOD!! user/group of all folders under ${nfs_mount_point} are 'root'"
  fi

  # Check if folder mode is 777
  execute_mode_test_result=$(ls -al ./test_nfs_mount_point | grep -v rwxrwxrwx| wc -l)
  if [[ ${execute_mode_test_result} != "3" ]]; then
    echo "===> BAD!! execute mode should be '0777'"
    ls -al ./test_nfs_mount_point
  else
    echo "===> GOOD!! execute mode of all folders under ${nfs_mount_point} are '0777'"
  fi


  echo ""
  echo "*Unmount test_nfs_mount_point"
  umount ./test_nfs_mount_point
  echo "*Delete test_nfs_mount_point"
  rm -rf ./test_nfs_mount_point

  # SELINUX (setsebool -P virt_use_nfs 1)
  selinux_test_result=$(getsebool virt_use_nfs|grep on|wc -l)
  if [[ ${selinux_test_result} != "1" ]]; then
    echo "===> BAD!! virt_use_nfs must be '1' (setsebool -P virt_use_nfs 1)"
    getsebool virt_use_nfs
  else
    echo "===> GOOD!! virt_use_nfs is 1"
  fi
fi

echo ""
echo "------------------------------ "
if [[ $connectivity_result == 0  && ${user_group_test_result} == 2 && ${execute_mode_test_result} == 3 && ${selinux_test_result} == "1" ]];then
    echo "** Result >> PASS !!"
else
    echo "** Result >> FAIL ;("
fi
