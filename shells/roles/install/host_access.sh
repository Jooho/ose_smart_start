For example, you can generate an SSH key on the host where you will invoke the installation process:

	# ssh-keygen
	Do not use a password.

		An easy way to distribute your SSH keys is by using a bash loop:

		# for host in master.example.com \
			    node1.example.com \
				    node2.example.com; \
					    do ssh-copy-id -i ~/.ssh/id_rsa.pub $host; \
							    done


setup.sh 
