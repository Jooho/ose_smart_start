. ./ose_config.sh 
password=redhat
echo $all_ip
for node in $all_hosts
do
  echo " "
  echo "Validate $node"
  echo " "
  #sshpass -p $password ssh root@$node '`subscription-manager clean; yum clean all; yum repolistr`'

   test="nc -v -i 2  node1.example.com 4793"
   echo "test $($test)"

  #read
done

