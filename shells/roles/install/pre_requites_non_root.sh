#This script main script for pre-requite with non root user.


# Copy ssh key with non root user

echo "Do you want to start from installing packages and updating system?(y/n)"
read do_install_package

if [[ do_install_package == y ]]; then
 #Install the following base packages:
 yum install wget git net-tools bind-utils iptables-services bridge-utils bash-completion nfs-utils -y

 #Update the system to the latest packages:
 yum update -y

 # if docker is not installed, it will install it.
 yum install docker -y
fi

#echo  $(hostname) == ${ansible_operation_vm}
if [[ $(hostname) == ${ansible_operation_vm} ]]
then
    #Install the following package, which provides OpenShift utilities and pulls in other tools required by the quick and
    #advanced installation methods, such as Ansible and related configuration files:
    yum install atomic-openshift-utils -y

    #To-Do
    # Check the non root user is under sudoers file. If not, this script will not work.
    ./copy_non_root_sshkey.sh
    ./copy_root_sskey.sh
    ./create_standard_bashrc_bashprofile.sh
