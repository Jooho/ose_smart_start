#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.05.25
# Purpose: Check whether OSE is installed well
#          validation_dns_look_up_router / validation_etcd_health / validation_oc_login / validation_port_open

# Included scripts:
#
#  - validation_dns_look_up_router.sh
#   Description :
#       This script check DNS entries for *${subdomain}.       
#   Execute Host: 
#        ose_cli_operation vm

#  - validation_etcd_health.sh
#   Description :
#       This script check etcd health
#   Execute Host: 
#        ose_cli_operation vm

#  - validation_oc_login.sh
#   Description :
#       This script check the api server is working well
#   Execute Host: 
#        ose_cli_operation vm

#  - validation_port_open
#   Description :
#       This script check necessary ports are opened
#   Execute Host: 
#        All VMs

. $CONFIG_PATH/ose_config.sh

echo "======================================================"
echo "========= Validate $ose_cli_operation_vm ============="
echo "======================================================"

echo ""
echo "***** validation_dns_look_up_router on $ose_cli_operation_vm ******"
echo ""
scp ./validation_dns_look_up_router.sh root@$ose_cli_operation_vm:${ose_temp_dir}/.
ssh -q root@${ose_cli_operation_vm} "sh ${ose_temp_dir}/validation_dns_look_up_router.sh"
read

echo ""
echo "***** validation_etcd_health on $ose_cli_operation_vm ******"
echo ""
scp ./validation_etcd_health.sh root@$ose_cli_operation_vm:${ose_temp_dir}/.
ssh -q root@${ose_cli_operation_vm} "sh ${ose_temp_dir}/validation_etcd_health.sh" 
read 

echo ""
echo "***** validation_oc_login on $ose_cli_operation_vm ******"
echo ""
scp ./validation_oc_login.sh root@$ose_cli_operation_vm:${ose_temp_dir}/.
ssh -q root@${ose_cli_operation_vm} "sh ${ose_temp_dir}/validation_oc_login.sh" 
read 

echo ""
echo "***** validation_port_open on $ose_cli_operation_vm ******"
echo ""
scp ./validation_port_open.sh  root@$ose_cli_operation_vm:${ose_temp_dir}/.
ssh -q root@${ose_cli_operation_vm} "sh ${ose_temp_dir}/validation_port_open.sh "
read 
