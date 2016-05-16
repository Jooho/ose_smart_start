. ../../config//ose_config.sh

cat << EOF > docker_registry_route.yaml
apiVersion: v1
kind: Route
metadata:
  name: registry
spec:
  host: ${docker_registry_route_url}
  to:
    kind: Service
    name: docker-registry 
  tls:
    termination: passthrough 

EOF

oc create -f ./docker_registry_route.yaml
rm -rf docker_registry_route.yaml

CA=/etc/origin/master

sudo mkdir -p /etc/docker/certs.d/${docker_registry_route_url}:5000
sudo cp $CA/ca.crt /etc/docker/certs.d/${docker_registry_route_url}:5000

