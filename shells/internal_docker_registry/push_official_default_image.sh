. ./images_conf.sh

for image in ${base_images}
do
	docker tag ${default_registry}/${image}  $(new_registry_url}/${image}
	docker tag ${default_registry}/${image}:${version}  $(new_registry_url}/${image}:${version}
	docker push ${new_registry_url}/${image}
	docker push ${new_registry_url}/${image}:${version}
#	echo "docker tag ${image}  $(echo ${image}|sed 's/registry.access.redhat.com/${new_docker_registry_url}/g')"
done



