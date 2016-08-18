#Disconnected Envrionment (External Docker Registry)

This script help you download/save/load/push images to a new docker registry as a official repository instead of registry.access.redhat.com

##Pre-requisite:
In order to use scripts, you need to execute this:
~~~
# cd ./ose_smart_start/
# source getReady.sh 
~~~ 


##Update config files:
1. If you already configured ${CONFIG_PATH}/ose_config.sh.default, you don't need to update config file.

2. If you want to use this role only, you need to do following steps:
   
2.1. Update $CONFIG_PATH/images_config.sh.31
~~~
export default_registry="registry.access.redhat.com"
export new_docker_registry_url="sourcehub.ao.dcn:5000"
export ose_version=3.1                    <====== Please add this value (No micro version)
export image_version=3.1.1.6              <====== Please add this value
~~~


##Execution Steps
If you execute this script on the external docker registry vm, you can skip step 2,3,4.

###Step 1. Download new official images 
~~~
cd ose_smart_start/shells/roles/internal_docker_registry

./1.download_official_images.sh
~~~

###Step 2. Archiving images to tar format
~~~
./2.save_images_from_docker.sh
~~~

###Step 3. Copying tar files to the external docker registry vm
~~~
scp *.tar sourcehub.ao.dcn:/var/lib/docker/.
~~~

###Step 4. Import images to docker 
~~~
cd ose_smart_start/shells/roles/internal_docker_registry
 
./3.load_image_to_docker.sh
~~~

###Step 5. Push images to docker registry 
~~~
./4.retag_and_push_official_images_to_docker_registry.sh
~~~

###Step 6. Update ImageStream in openshift project  (login with cluster admin user to openshift before execute it)
~~~
 ./5.clean_create_imagestream_in_openshift_proj.sh
~~~

##Trouble shooting
###Case 1. If integrated docker registry is not running after you finish all steps above, try this script
~~~
./change_docker_registy_version.sh
~~~

###Case 2. If you encounter a issue that an ImageStream is not found, try this
~~~
./update_is_in_openshift.sh
~~~