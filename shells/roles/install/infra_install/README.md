INFRA_INSTALL	
----

Each shell script has numberic order and you can easily understand the script with title. Some shell scripts might not be needed  These scripts are sample scripts so you shoule create your own scripts. For example, if you don't use satellite, you can remove it and create new script to register RHN.


### Pre requisite

Ansible playbook vm must have accessibility to every VM including NFS server.

### OCP Install Steps:
1. copy_sshkey_osadmin.sh   
2. copy_ose_script.sh
3. execute_remote_sh_for_3-1.sh 
	- 3-1.change_ssh_conf_allow_root_user.sh
4. execute_remote_sh_for_4-1.sh
	-	4-1.satellite_subscription.sh
5. execute_remote_sh_for_5-1.sh
	- 5-1.install_essential_packages.sh  
6. storage_setup.sh 
7. change_selinux.sh
8. config_ansible_docker.sh
- install_OSCP.sh



### Config/Deploy after OCP installation
0.	squid.sh
	- 0-1.install_configure_squid.sh
	- 0-2.add_proxy_information_docker_ose.sh
	- 0-3.create_squid_svc.sh
	- 0-4.create_squid_iptables.sh
1. ldap.sh
	- 1-1.install_stunnel.sh
	- 1-2.config_master-config.sh
	- 1-3.ldap.yaml
2. change_login_page.sh
3. webconsole.sh
	- 3-1.change_webconsole_cert.sh
4. import_fuse_is.sh
5. execute_remote_sh_for_5-1.sh
	- 5-1.import_court_cert.sh
6. open_port_iptables.sh
7. config_docker_registry.sh
8. deploy_router.sh
9. execute_remote_sh_for_9-1.sh
	- 9-1.config_rsyslog_logrotate.sh
10. execute_remote_sh_for_10-1.sh
	- 10-1.expose_docker_registry.sh
11. auth_token_timeout.sh
12. proxy_userspace.sh
13. disable_cockpit.sh
14. disable_ssh_with_root.sh

