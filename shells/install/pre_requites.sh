. ../ose_config.sh

#Install the following base packages:
yum install wget git net-tools bind-utils iptables-services bridge-utils bash-completion nfs-utils -y

#Update the system to the latest packages:
yum update -y

# if docker is not installed, it will install it.
yum install docker -y

echo  $(hostname) == ${ansible_operation_vm} 
if [[ $(hostname) == ${ansible_operation_vm} ]]
then
    #Install the following package, which provides OpenShift utilities and pulls in other tools required by the quick and
    #advanced installation methods, such as Ansible and related configuration files:
   
    yum install atomic-openshift-utils -y

    # Generate public key
    ssh-keygen
    echo -e "Do you want to copy id_rsa.pub file to all machines with 1 password?(y/n) \c"
    read copy_pub_file_with_one_password
    
    #ssh-copy-id to each hosts
    if [[ $copy_pub_file_with_one_password == "y" ]]
    then
       echo -e "Type password : \c"
       read password
       echo "~/.ssh/id_rsa.pub file will be copyed to : "
       echo " $hosts"
       for host in $all_hosts;
       do
          sshpass -p $password ssh-copy-id -i  ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@$host
       done
    else
       echo "~/.ssh/id_rsa.pub file will be copyed to : $hosts"
       for host in $hosts;
       do
          ssh-copy-id -i ~/.ssh/id_rsa.pub root@$host;
       done
    fi
# Node only has docker-storage
elif [[ $(hostname) =~ ${node_prefix} ]]
then
#Docker storage configure
# ansible role : ose_docker_configure

cat << EOF > /etc/sysconfig/docker-storage-setup
DEVS=/dev/${docker_storage_dev}
VG=docker-vg
EOF

docker-storage-setup

fi

#Common
#docker log max 
echo "add log configuration to docker"
log_config_exit=$(grep log-opt /etc/sysconfig/docker|wc -l)
if [[ $log_config_exit == 0 ]]; then
    sed -e "s/^OPTIONS=/OPTIONS=--log-opt max-size=${docker_log_max_size} --log-opt max-file=${docker_log_max_file} /g" -i /etc/sysconfig/docker
fi


#If Docker has not yet been started on the host, enable and start the service:

echo "Stop Docker"
systemctl enable docker
systemctl stop docker
rm -rf /var/lib/docker/*
systemctl start docker

echo "Start Docker"
ps -ef|grep docker
