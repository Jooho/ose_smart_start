NFS_SERVER=test
NFS_MOUNT_POINT=mount

echo "oc volume deploymentconfigs/docker-registry --add --overwrite --name=registry-storage  --mount-path=/registry --source='{\"nfs\": { \"server\": \""${NFS_SERVER}\"", \"path\":   \""${NFS_MOUNT_POINT}/ose-registry\""}}'"


