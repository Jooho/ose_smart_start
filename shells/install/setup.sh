
function mount_temp_repository(){
     mkdir -p /var/iso_images/rhel
     mkdir -p /var/iso_images/ose
     mount -o loop,ro ./$rhel_iso_file /var/iso_images/rhel
     mount -o loop,ro ./$ose_iso_file /var/iso_images/ose

if [ -f /etc/yum.repos.d/ose.repo ]
then
  rm -rf /etc/yum.repos.d/ose.repo
fi

     cat <<'EOF' >> /etc/yum.repos.d/ose.repo
[ose]
name=Openshift v3
baseurl=file:///var/iso_images/ose/rhel-7-server-ose-3.1-rpms
enabled=1
gpgcheck=0
[rhel]
name=RHEL 7.1
baseurl=file:///var/iso_images/rhel
enabled=1
gpgcheck=0
EOF

}


function umount_temp_repository(){
     umount /var/iso_images/rhel
     umount /var/iso_images/ose
     rm -rf /var/iso_images
}

function usage(){
cat <<EOF 
# Usage : 
#        ./setup.sh   ./inventory_file.yaml
#
#   Condition: internet_connected must set true and subscription-manager as well. Or rhel-7-server, rhel-7-ose-3.1 iso files must be in /root/ose.

EOF
}


# start script
if [[ $1 == "" ]]
then 
  echo "please specify inventory file"
  usage
  exit 1
else
  inventory_file=$1
fi

# Variable set up
export inventory_file
export internet_connected=$(grep  "internet_connected=" $1 |grep -v ^# |cut -d"=" -f2)
export rhel_iso_file=$(grep -i rhel_iso_long ./$inventory_file  |cut -d"=" -f2|awk '{gsub( "\"","" ); print}')
export ose_iso_file=$(grep -i ose_iso_long ./$inventory_file  |cut -d"=" -f2|awk '{gsub( "\"","" ); print}')
export mount_temp_repo_statue="unmounted"

# Domain "example.com"
export domain=$(grep ^master ./$inventory_file |sed -n '2p' |cut -d" " -f1 |awk -F . {'print $2 "." $3'};)

# IP information about master/node/etcd/lb/infra
export hosts=$(grep "example.com" ./$inventory_file | awk -F "ansible_ssh_host=" '{print $2}'|cut -d" " -f1|grep -v "^$" |awk '{print  $1 " "  }')

 
# Check if generating public key is needed 
echo -e "Do you want to go through from the beginning?(y/n) (or just start to install)"
read need_generating_public_key

if [ $need_generating_public_key == "y" ]
then
   # Mount temp repository
   if [ $internet_connected == false ]; 
   then 
     mount_temp_repository
     mount_temp_repo_statue=mounted
   fi
  
   # Install necessary package
   yum install -y atomic-openshift-utils sshpass git wget net-tools bind-utils  bridge-utils bash-completion
   
   #Umount temp repository
   if [ $mount_temp_repo_statue == mounted ]; 
   then
     umount_temp_repository
     mount_temp_repo_statue=umounted
     rm /etc/yum.repos.d/ose.repo
   fi
   
   # Generate public key
   ssh-keygen
   echo -e "Do you want to copy id_rsa.pub file to all machines with 1 password?(y/n) \c"
   read copy_pub_file_with_one_password
   
   #ssh-copy-id to each hosts
   if [ $copy_pub_file_with_one_password == "y" ]
   then 
      echo -e "Type password : \c"
      read password
      echo "~/.ssh/id_rsa.pub file will be copyed to : "
      echo " $hosts"
      for host in $hosts; do
   	 sshpass -p $password ssh-copy-id -i  ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no root@$host
      done
   else
      echo "~/.ssh/id_rsa.pub file will be copyed to : $hosts"
       for host in $hosts; do
         ssh-copy-id -i ~/.ssh/id_rsa.pub root@$host;
       done
   fi
git clone https://github.com/Jooho/ansible-ose3-install

else
echo "nameserver 8.8.8.8" > /etc/resolv.conf
cd ansible-ose3-install;git pull;cd ..

fi  



~/dev/git/mine/ose_smart_start
#Install the following base packages:

yum install wget git net-tools bind-utils iptables-services bridge-utils bash-completion

#Update the system to the latest packages:

yum update

#Install the following package, which provides OpenShift utilities and pulls in other tools required by the quick and
#advanced installation methods, such as Ansible and related configuration files:

yum install atomic-openshift-utils

# if docker is not installed, it will install it.
yum install docker

#Docker storage
# ansible role : ose_docker_configure

#Check if Docker is running:

systemctl is-active docker

#If Docker has not yet been started on the host, enable and start the service:

systemctl enable docker
systemctl stop docker
rm -rf /var/lib/docker/*
systemctl restart docker

# docker log max
--log-opt max-size=1M --log-opt max-file=3
