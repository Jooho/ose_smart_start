. $CONFIG_PATH/ose_config.sh


get_specific_hosts_ips(){

export prefix
export need_host_ip

case "$1" in
	master)
		prefix="master_prefix"
		;;
	node)
		prefix="node_prefix"
		;;
	etcd)
		prefix="etcd_prefix"
		;;
	*)
		echo "Usage: get_specific_hosts_ips() [master|node|etcd] [ip|host]"
        exit 1
     esac
#echo $prefix
case "$2" in
	ip)
		need_host_ip="ip"
		;;
	host)
		need_host_ip="host"
		;;
	*)
		echo "Usage: get_specific_hosts_ips() [master|node|etcd] [ip|host]"
        exit 1

   esac

#echo $need_host_ip
nested_prefix_value=$prefix
export detected_ip
export detected_host
while read host
do
#   echo "prefix : ${!nested_prefix_value}"
     if [[ $host =~ ${!nested_prefix_value} ]]; then
        if [[ $need_host_ip == "host" ]]; then
	   hostname=$(echo $host | awk '{print $1}')
	   echo $hostname
	   detected_host=("${detected_host[@]}" "${hostname}")
	else
	   ip=$(echo $host | awk '{print $2}')
	   detected_ip=("${detected_ip[@]}" "${ip}")
	fi
     fi
done < ${CONFIG_PATH}/${host_file}

if [[ $need_host_ip == "host" ]]; then
    echo $(echo ${detected_host[@]})
else
    echo $(echo ${detected_ip[@]})
fi
}
echo ${CONFIG_PATH}/${host_file}
fun=$(get_specific_hosts_ips master ip| tr -s " " "," )

echo "test $fun"

