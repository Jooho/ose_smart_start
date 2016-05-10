. ../ose_config.sh

cat << EOF > docker_registry_route.yaml
apiVersion: v1
kind: Route
metadata:
  name: registry
spec:
  host: registry.cloudapps.example.com
  to:
    kind: Service
    name: docker-registry 
  tls:
    termination: passthrough 

EOF

oc create -f ./docker_registry_route.yaml
