#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.21
# Purpose: This script save official docker images to tar format
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160721   jooho  create
#
#
#

. $CONFIG_PATH/ose_config.sh

 echo "Archiving base images.." 
 docker save -o ose3-images.tar $base_images

 echo "Archiving metrics_logging images.." 
 docker save -o ose3-logging-metrics-images.tar $logging_metrics_images

 echo "Archiving s2i images.." 
 docker save -o ose3-builder-images.tar $builder_images

 echo "Archiving xpaas images.." 
 docker save -o ose3-xpaas-images.tar $xpaas_images
