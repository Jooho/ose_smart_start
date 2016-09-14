#!/bin/bash
#
#  Author: Jooho Lee(ljhiyh@gmail.com)
#    Date: 2016.08.18
# Purpose: This script check there is new images after ose upgrade
#
# History:
#          Date   |  who  |  Changes
#========================================================================
#        20160818   jooho    Create
#

. $CONFIG_PATH/ose_config.sh

export old_images=ose_${old_ose_version}_images.txt
export new_images=ose_${ose_version}_images.txt
export diff_images=diff_images.txt.temp
touch diff_images.txt.temp

if [[ -e ./$new_images ]]
then
  echo " $new_images exist so it will use it."
else
  touch $new_images

  for is in $base_images $logging_metrics_images $builder_images $fis_images $jboss_images
  do
      echo $is >> $new_images
  done
fi

echo "" 
for new_image in $(cat ./$new_images)
do
   export new=true

   for old_image in $(cat ./$old_images)
   do
      if [[ $new_image == $old_image ]] 
      then
         new=false
         break
     fi
   done


   if [[ $new == "true" ]]
   then 
     echo " $new_image == $old_image"
     echo $new_image >> $diff_images
   fi
done

echo ""
echo " The new images are stored in $diff_images.txt.temp file "
echo " You have to create group/projects in gitlab according to the result images before move on "
echo ""
  
