#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.21
# Purpose: This script download all official images from registry.access.redhat.com
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160721   jooho  Create
#        20160816   jooho  Download all tags
#        20160817   jooho  remove all tags and add 2 foreach statement
#
#
#
##############################################################################

. $CONFIG_PATH/ose_config.sh

docker images
echo "Before you execute it, please make sure there are no images when you execute 'docekr images'"
echo "If there are some images, please delete them all"
echo "Command to delete all images : for image in $(docker images|awk '{print $1}'); do docker rmi $image ; done"

export correct_answer="false"
while [ $correct_answer == "false" ]
do
        echo -n "Do you want to continue?(y/n)"
        read continue_work
        if [[ $continue_work == "y" ]]; then
           echo "** Download images **"
           correct_answer=true
        elif [[ $continue_work == "n" ]]; then
           echo "** STOP **"
           exit 1
        fi
        else
           echo "Please choose y or n only."
        fi
done

# It will pull only latest tag of all images
for image in $base_images $logging_metrics_images $builder_images ${xpaas_images}
do 
              docker pull $image 
done

# xpaas images are using tag for each version. For example, openshift 3.1.6 need 1.0/1.1/1.2
# It will download some specific tags of images and it could show errors like there is no such image:tag. Please ignore it.
for image in ${xpaas_images}
do 
              docker pull $image:1.0 
              docker pull $image:1.1
              docker pull $image:1.2 
done

