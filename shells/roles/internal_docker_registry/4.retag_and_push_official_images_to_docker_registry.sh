#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.21
# Purpose: This script retag official images and push them to new docker registry
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160721   jooho  create
#        20160816   jooho  push all tags
#
#
#

. $CONFIG_PATH/ose_config.sh

<<<<<<< HEAD
for image in ${base_images} ${logging_metrics_images} ${builder_images} ${fis_images} ${jboss_images}
=======
for image in ${base_images} ${logging_metrics_images} ${builder_images} ${xpaas_images}
>>>>>>> 43988bd5590e1d39e87ad520628990f0ede52ae3
do

       for tag in $(docker images |grep $image |awk '{print $1 "/" $2}')
       do
          project_name=$(echo $tag |cut -d/ -f2)
          image_name=$(echo $tag |cut -d/ -f3)
          tag=$(echo $tag |cut -d/ -f4)
          echo "docker tag ${image}:${tag}  ${new_docker_registry_url}/${project_name}/${image_name}:${tag}"
          docker tag ${image}:${tag}  ${new_docker_registry_url}/${project_name}/${image_name}:${tag}
          docker push ${new_docker_registry_url}/${project_name}/${image_name}:${tag}
       done
done

