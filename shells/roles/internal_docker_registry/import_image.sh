
for image in $(oc get is |grep -v registry.access|grep -v REPO |awk '{print $1}') ;
do
  oc get  is $images -n openshift -o json|sed  "s/192.168.200.108:5000/registry.access.redhat.com/g" > ${image}_is.yaml 
  #echo "oc get  is $images -n openshift -o json|sed 's/192.168.200.108:5000/registry.access.redhat.com/g' > ${image}_is.yaml "
  oc replace -f ${image}_is.yaml -n openshift
  #echo "oc replace -f ${image}_is.yaml -n openshift"
  rm -rf ./${image}_is.yaml
  #echo "rm -rf ./${image}_is.yaml"

done
