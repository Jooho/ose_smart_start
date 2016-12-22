 . ${CONFIG_PATH}/ose_config.sh

# This method create pvc yaml script
function create_pvc_script(){
  #VOL_NAME=${PV_NAME_PREFIX}${c}
  VOL_NAME=$1
cat << EOF > ${PVC_SCRIPT_PATH}/${VOL_NAME}
apiVersion: "v1"
kind: "PersistentVolumeClaim"
metadata:
  name: ${VOL_NAME}
spec:
  accessModes:
    - ${PVC_ACCESS_MODE}
  resources:
    requests:
      storage: ${LVM_VOL_SIZE}Gi
EOF
  echo "Created def file for ${VOL_NAME}"
}



export exist_pvc
export created_pvc

#Check if PVC_SCRIPT_PATH is exist. If exist, skip but don't exist, it will create the folder
if [[ -e ${PVC_SCRIPT_PATH} ]]; then
  echo "${PVC_SCRIPT_PATH} is exist so it is not created."
else
  echo "${PVC_SCRIPT_PATH} is not exist so it is created."
  mkdir -p ${PVC_SCRIPT_PATH}
fi

# Flow
# 1. Check if there is same name of pv on openshift
# 2.1. If there is, it does not create even pv script.
# 2.2. If there is not, it create pv script under ${PV_SCRIPT_PATH}.
# 3. It will execute "oc create -f" with pv script
# 4. Ask if the pv script and folder remain or not.


for c in $(seq -f "%0${#LVM_NAME_RANGE_PAD}g" ${LVM_RANGE_START} ${LVM_RANGE_END})
do

 #lvm vol name
 FORMATTED_LVM_SIZE=$(seq -f "%0${#LVM_NAME_SIZE_PAD}g" ${LVM_VOL_SIZE} ${LVM_VOL_SIZE})
 LVM_VOL_NAME="${LVM_NAME_PREFIX}${FORMATTED_LVM_SIZE}g${c}"

 # pvc name
 VOL_NAME="${PVC_NAME_PREFIX}-${NFS_SERVER_TAG}-${LVM_VOL_NAME}"
 VOL_NAME="$(echo $VOL_NAME|sed 's/_/-/g')"
 pvc_exist=$(oc get pvc |grep  ${VOL_NAME} |wc -l)

 if [[ $pvc_exist -eq 1 ]]; then
      echo "${VOL_NAME} pvc is already created so skip to create the persistent volume claim!!"
      exist_pvc=("${exist_pvc[@]}" "${VOL_NAME}")
  else
      echo "Creating ${VOL_NAME} pvc script"
      create_pvc_script ${VOL_NAME}
      oc create -f ${PVC_SCRIPT_PATH}/${VOL_NAME}

      check_pvc_is_created=$(oc get pvc|grep ${VOL_NAME}|wc -l)

      if [[ $check_pvc_is_created == 1 ]]; then
        created_pvc=("${created_pvc[@]}" "${VOL_NAME}")
      else
        echo "There were issues to create pvc. Check user role"
      fi

  fi
done;

echo ""
echo ""
echo ""
echo "Summary :"
echo "====================================================="
echo "Exist pvc :"
echo ${exist_pvc[@]}
echo ""
echo Created pvc  :
echo ${created_pvc[@]}
echo ""
echo ""
oc get pvc
echo ""

export finish="false"
while [ $finish == "false" ]
do
   echo -e "Do you want to clean all stuff such as pv scripts/folder?(y/n)"
   read clean
   if [ $clean == "y" ]; then
     echo "cleaning all stuff"
     rm -rf  ${PVC_SCRIPT_PATH}
     finish="true"
   elif [ $clean == "n" ]; then
     echo "OK, you can see scripts from here :${PVC_SCRIPT_PATH}"
     finish="true"
   else
     echo "You should type one of y or n!!!"
   fi
done

