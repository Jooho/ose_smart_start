echo "$(cat hosts.smart |grep ^# -n |cut -d: -f1)"
line=$(cat hosts.smart |grep ^# -n |cut -d: -f1)

if [[ $line == "" ]];then
	echo $(cat hosts.smart |awk '{print $2}')

else

echo $(cat hosts.smart |awk '{print $1}'|sed "${line},100d")
fi
