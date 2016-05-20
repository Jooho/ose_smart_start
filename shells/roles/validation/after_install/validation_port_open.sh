. $CONFIG_PATH/ose_config.sh


if [[ $(hostname) =~ ${master_prefix} ]]; then

   for host in $all_hosts
   do
     if [[ $host =~ ${node_prefix} ]]; then
       #Master to Node
       echo ""
       echo "================================================"
       echo "Check if ports are opened from Master to Node"
       echo "================================================"

       echo "From $(hostname) To $host : 4789(UDP)"
       deny_master_node_4789=$(nc -i1 -u $host 4789 2>&1 |grep "Idle timeout expired"| wc -l)
       if [[ $deny_master_node_4789 == 1 ]]; then
          echo "==> Result : PASS !!"
       else
          echo "==> Result : Fail ;("
       fi 
        
       echo ""
       echo "From $(hostname) To $host : 10250(TCP)"
       deny_master_node_10250=$(nc -i1 $host 10250 2>&1 |grep "Idle timeout expired"| wc -l)
       if [[ $deny_master_node_10250 == 1 ]]; then
          echo "==> Result : PASS !!"
       else
          echo "==> Result : Fail ;("
       fi 
     elif [[ $host =~ ${master_prefix} && $host != $(hostname) ]]; then
       echo ""
       #Master to Master
       echo "================================================"
       echo "Check if ports are opened from Master to Master"
       echo "================================================"
       echo "From $(hostname) To $host : 4789(UDP)"
       deny_master_master_4789=$(nc -i1 -u $host 4789 2>&1|grep "Idle timeout expired"| wc -l)
       if [[ $deny_master_master_4789 == 1 ]]; then
          echo "==> Result : PASS !!"
       else
          echo "==> Result : Fail ;("
       fi 
       
       echo ""
       echo "From $(hostname) To $host : 53(TCP)"
       deny_master_master_53=$(nc -i1 $host 53 2>&1 |grep "Idle timeout expired"| wc -l)
       if [[ $deny_master_master_53 == 1 ]]; then
          echo "==> Result : PASS !!"
       else
          echo "==> Result : Fail ;("
       fi 
 
       echo ""
       echo "From $(hostname) To $host : 2379(TCP)"
       deny_master_master_2379=$(nc -i1 $host 2379 2>&1 |grep "Idle timeout expired"| wc -l)
       if [[ $deny_master_master_2379 == 1 ]]; then
          echo "==> Result : PASS !!"
       else
          echo "==> Result : Fail ;("
       fi 

       echo ""
       echo "From $(hostname) To $host : 2380(TCP)"
       deny_master_master_2380=$(nc -i1 $host 2380 2>&1|grep "Idle timeout expired"| wc -l)
       if [[ $deny_master_master_2380 == 1 ]]; then
          echo "==> Result : PASS !!"
       else
          echo "==> Result : Fail ;("
       fi 

       #for non_cluster etcd
       #echo ""
       #echo "From $(hostname) To $host : 4001(TCP)"
       #deny_master_master_4001=$(nc -i1 $host 4001 2>&1 |grep "Idle timeout expired"| wc -l)
       #if [[ $deny_master_master_4001 == 1 ]]; then
       #   echo "==> Result : PASS !!"
       #else
       #   echo "==> Result : Fail ;("
       #fi 
    fi
   done 

elif [[ $(hostname) =~ ${node_prefix} ]]; then
   for host in $all_hosts
   do
     if [[ $host =~ ${node_prefix} ]]; then
       #Node to Node
       echo ""
       echo "================================================"
       echo "Check if ports are opened from Node to Node"
       echo "================================================"
       echo "From $(hostname) To $host : 4789(UDP)"
       deny_master_node_4789=$(nc -i1 -u $host 4789 2>&1|grep "Idle timeout expired"| wc -l)
       if [[ $deny_master_node_4789 == 1 ]]; then
          echo "==> Result : PASS !!"
       else
          echo "==> Result : Fail ;("
       fi 
     elif [[ $host =~ ${master_prefix} ]]; then
       echo ""
       #Nodes to Master
       echo "================================================"
       echo "Check if ports are opened from Node to Master"
       echo "================================================"
       echo "From $(hostname) To $host : 8443(TCP)"
       deny_master_node_8443=$(nc -i1 $host 8443 2>&1 |grep "Idle timeout expired"| wc -l)
       if [[ $deny_master_node_8443 == 1 ]]; then
          echo "==> Result : PASS !!"
       else
          echo "==> Result : Fail ;("
       fi 

       echo ""
       echo "From $(hostname) To $host : 53(TCP)"
       deny_master_master_53=$(nc -i1 $host 53 2>&1|grep "Idle timeout expired"| wc -l)
       if [[ $deny_master_master_53 == 1 ]]; then
          echo "==> Result : PASS !!"
       else
          echo "==> Result : Fail ;("
       fi
     fi
  done
fi

#IaaS deployment
#22
#53
#80 or 443
#1936
#4001
#2379 or 2380
#4789
#8443
#10250
#24224


#To-Do List
#External to Master
#443 or 8443

#External to LB
#443 or 8443

