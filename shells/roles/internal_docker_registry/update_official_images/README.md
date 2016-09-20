Update Official images (for DISCONNECTED ENVIRONMENT)
---

This script help update official images in internal docker registry instead of `registry.access.redhat.com`

##SCRIPTS
1. download_official_images.sh
2. save_images_from_docker.sh
3. load_image_to_docker.sh
4. retag_and_push_official_images_to_docker_registry.sh
5. clean_create_imagestream_in_openshift_proj.sh


##INFORMATION FILES
	is_delete_list_3.1.txt
		It contains official imagesStream list in OCP 3.1
	is_delete_list_3.2.txt
		It contains official imagesStream list in OCP 3.2


##UTIL
### Check new image
When you use gitlab as a docker registry, this script help list up new images which should be created in gitlab before pushing. Gitlab provide 1 to 1 map so you have to create group/project for each image. Check `ose_version` in ose_config.sh.${yours}

###Usage
	checking_images.sh
	
	Result
    diff_images.txt.temp
	
	
### Redeploy docker registry with new version
After ose upgrade, you need to redeploy docker registry with new image. This script change verion of image, then OSE will redeploy it.

###Usage
	change_docker_registy_version.sh


### Update ImageStream in openshift project
This is manual IS update script for openshift project

### Usage
	update_is_in_openshift.sh

