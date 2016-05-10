
cat all_images |sed 's/registry.access.redhat.com/192.168.200.108:5000/g' > all_images_new_tag

for image in $(cat all_images)
do
	docker tag ${image}  $(echo ${image}|sed 's/registry.access.redhat.com/192.168.200.108:5000/g')
#	echo "docker tag ${image}  $(echo ${image}|sed 's/registry.access.redhat.com/192.168.200.108:5000/g')"
done


for image in $(cat all_images_new_tag)
do
	docker push ${image}
#	echo "docker push ${image}"
done

