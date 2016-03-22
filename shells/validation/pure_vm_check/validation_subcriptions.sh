. ../../ose_config.sh 

yum_repolist="rhel-7-server-extras-rpms rhel-7-server-ose-3.1-rpms rhel-7-server-rpms rhel-ha-for-rhel-7-server-rpms"



export success=0
export yum_repolist_count=0
yum clean all; yum repolist > ./yum_repolist.out
for repo in $yum_repolist
do
  yum_repolist_count=$((yum_repolist_count + 1))
  temp_result=$(grep -c "$repo" ./yum_reoplist.out)
  if [[ $? == 0 ]]; then
     echo "$repo is attached"
     success=$((success + 1))
  fi
  done
done

echo "------------------------------ "
echo "Needed repolist count :  $yum_repolist_count "
echo "Attached VM count : $success"
cat ./yum_repolist.out
if [[ $yum_repolist_count == $success ]];then
  echo "PASS !!"
else
  echo "FAIL ;("
fi
