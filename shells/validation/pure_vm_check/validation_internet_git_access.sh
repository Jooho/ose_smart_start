# Internet connectivity (using github.com, registry.access.redhat.com)
. ../../ose_config.sh
export url_list="github.com registry.access.redhat.com"

export success=0
export test_url_list=0
for url in $url_list
do
  test_url_list=$((test_url_list + 1))
  dig_test_result=$(dig $url |grep ANSWER: |awk '{print $9}'|sed "s/,//g")
  ping_test_result=$(ping -c 1 $url |grep "unknown host"|wc -l)
  if [[ $dig_test_result != 0 &&  $ping_test_result == 0 ]]; then
     echo "$url is accessed successfully"
     success=$((success + 1))
    fi
done

echo "------------------------------ "
echo "Tested URL count :  $test_url_list "
echo "Success URL count : $success"
if [[ $test_url_list == $success ]];then
  echo "PASS !!"
else
  echo "FAIL ;("
fi
