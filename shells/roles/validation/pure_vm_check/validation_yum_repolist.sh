#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.20
# Purpose: Check if yum repolist are attached

. $CONFIG_PATH/ose_config.sh 

export success=0
export yum_repolist_count=0
yum clean all; yum repolist > ./yum_repolist.out
# yum repolist > ./yum_repolist.out
for repo in $yum_repolist
do
  yum_repolist_count=$((yum_repolist_count + 1))
  echo "$(grep -c "$repo" ./yum_repolist.out)"
  temp_result=$(grep -c "$repo" ./yum_repolist.out)
echo "$repo"
  if [[ $? == 0 ]]; then
     echo "$repo is attached"
     success=$((success + 1))
  fi
done

echo "------------------------------ "
echo "Needed repolist count :  $yum_repolist_count "
echo "Attached repolist count : $success"
cat ./yum_repolist.out
rm ./yum_repolist.out
if [[ $yum_repolist_count == $success ]];then
    echo "** Result >> PASS !!"
else
    echo "** Result >> FAIL ;("
fi
