mkdir ./test
for image in $(oc get is -n openshift|grep -v registry.access|grep -v REPO |awk '{print $1}')  
do 
        echo $image
	oc describe is $image -n openshift|grep -v registry.access > ./test/${image}_images

        while read line
        do 
           echo "echo $line|awk '{print $2}'|grep registry"
           if [[ z$(echo $line|awk '{print $2}'|grep registry) != z ]]; then
             # docker pull $(echo $line|awk '{print $2}'|grep registry)
               echo $line|awk '{print $2}'|grep registry >> ./test/all_images 
           fi
 
        done < ./test/${image}_images
#rm ./${image}_images
done
exit 0
for image in $(oc get is -n openshift |grep registry.access|grep -v REPO |awk '{print $1}') ;
do
        
        oc describe is ${image} -n openshift|grep registry|awk '{print $1  "  "  $5   " " $6}' > ./test/${image}_images

        while read line;
        do 
           if [[ z$(echo $line|awk '{print $2}'|grep registry) != z ]]; then
             # docker pull $(echo $line|awk '{print $2}'|grep registry)
               echo $line|awk '{print $2}'|grep registry >> test/all_images 
           else
             # docker pull $(echo $line|awk '{print $3}'|grep registry) 
               echo $line|awk '{print $3}'|grep registry >> test/all_images 
           fi
        done < ./test/${image}_images
#rm ./${image}_images
done
