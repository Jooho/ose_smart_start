for image in $(oc get is |grep -v registry.access|grep -v REPO |awk '{print $1}') ; 
do 
	oc describe is $image|grep registry.access > ${image}_images

        while read line
        do 
           if [[ z$(echo $line|awk '{print $2}'|grep registry) != z ]]; then
             # docker pull $(echo $line|awk '{print $2}'|grep registry)
               echo $line|awk '{print $2}'|grep registry >> all_images 
           fi
 
        done < ./${image}_images
rm ./${image}_images
done


for image in $(oc get is |grep registry.access|grep -v REPO |awk '{print $1}') ;
do
        
        oc describe is ${image} |grep registry|awk '{print $1  "  "  $5   " " $6}' > ${image}_images

        while read line;
        do 
           if [[ z$(echo $line|awk '{print $2}'|grep registry) != z ]]; then
             # docker pull $(echo $line|awk '{print $2}'|grep registry)
               echo $line|awk '{print $2}'|grep registry >> all_images 
           else
             # docker pull $(echo $line|awk '{print $3}'|grep registry) 
               echo $line|awk '{print $3}'|grep registry >> all_images 
           fi
        done < ./${image}_images
rm ./${image}_images
done
