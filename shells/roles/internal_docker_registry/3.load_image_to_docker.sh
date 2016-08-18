#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.07.21
# Purpose: This script load official docker images to docker
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160721   jooho  create
#
#
#

. $CONFIG_PATH/ose_config.sh

 echo "Load base images"
 docker load -i ose3-images.tar 

 echo "Load metrics_logging images"
 docker load -i ose3-logging-metrics-images.tar 

 echo "Load s2i images"
 docker load -i ose3-builder-images.tar 

 echo "Load xpaas images"
 docker load -i ose3-xpaas-images.tar 
