. ../ose_config.sh

if [[ $(hostname) =~ $ansible_operation_vm ]]; then
	echo "HERE"
else
	echo "NOPE"
fi
