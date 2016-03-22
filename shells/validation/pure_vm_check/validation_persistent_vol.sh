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
  sudo mount -t nfs infra.example.com:${nfs_mount_point} ./test_nfs_mount_point
  # Check if folder user is nfsnobody
  echo ""
  user_group_test_result=$(ls -al ./test_nfs_mount_point |grep -v nfsnobody| wc -l)
  if [[ ${user_group_test_result} != "3" ]]; then
    echo "===> BAD!! user/group should be 'nfsnobody'"
  else
    echo "===> GOOD!! user/group of all folders under ${nfs_mount_point} are 'nfsnobody'"
  fi

  # Check if folder mode is 777
  execute_mode_test_result=$(ls -al ./test_nfs_mount_point | grep -v rwxrwxrwx| wc -l)
  if [[ ${execute_mode_test_result} != "3" ]]; then
    echo "===> BAD!! execute mode should be '0777'"
  else
    echo "===> GOOD!! execute mode of all folders under ${nfs_mount_point} are '0777'"
  fi


  echo ""
  echo "*Unmount test_nfs_mount_point"
  sudo umount ./test_nfs_mount_point
  echo "*Delete test_nfs_mount_point"
  rm -rf ./test_nfs_mount_point
fi

echo ""
echo "------------------------------ "
echo "Success VM count : $success"
if [[ $connectivity_result == 0  && ${user_group_test_result} == 3 && ${execute_mode_test_result} == 3 ]];then
    echo "PASS !!"
else
    echo "FAIL ;("
fi
