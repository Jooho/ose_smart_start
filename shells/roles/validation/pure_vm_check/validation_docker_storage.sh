#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.20
# Purpose: the lvm is configured for docker stroage

# Check if docker-storage is added
. $CONFIG_PATH/ose_config.sh

echo "* Check if docker-storage is added"
docker_storage_test_result=$(lvs |grep docker-pool| wc -l)

if [[ $docker_storage_test_result != 1 ]]; then
  echo "===> BAD!! docker-storage should be added"
  echo "===> But you can configure it during the pre_requite process"
  lvs
else
  echo "===> GOOD!! docker-storage lvm is added"
fi

echo ""
echo "------------------------------ "
if [[ $docker_storage_test_result == 1 ]]; then
    echo "** Result >> PASS !!"
else
    echo "** Result >> FAIL ;("
fi
