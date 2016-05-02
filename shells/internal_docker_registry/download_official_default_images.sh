. ./images_conf.sh

for image in $base_images
do 
              docker pull ${default_registry}/${image}
              docker pull ${default_registry}/${image}:${version}
done


