# Overview


ose_smart_script use ssh connection to execute remote shell script, which means every vms have to have same configuration. However, it also contains ad-hoc shell script so you can execute those scripts without configuration files.

## Architecture
[Simple architect how to execuete remote shell](./architecture.jpg)


## Functions
1) calc() 

	# This is for calculating float value such as 3.2 - 3.1 = 0.1
	# Usage
	# old_ose_version=$(calc "$ose_version - 0.1")

2) get_specific_hosts_ips()

	### Usage
	# get_specific_hosts_ips() [master|node|etcd|infra] [ip|host]		
	
	# Example
	# fun=get_specific_hosts_ips master ip
	# echo "Master IP list : $fun"
	
	# test 10.162.19.240 10.162.19.241 10.162.19.242

    # Tip 	
    # space between IPs can be replaced of another delimeter
    # $(get_specific_hosts_ips master ip| tr -s " " "," )
    # 10.162.19.240,10.162.19.241,10.162.19.242


