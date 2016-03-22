#Node to Node
4789

#Nodes to Master
53
4789
443 or 8443

#Master to Node
4789
10250

#Master to Master
53
2379

2380

4001
4789

#External to Master
443 or 8443


#IaaS deployment
22
53
80 or 443
1936
4001
2379 or 2380
4789
8443
10250
24224


#Notes
#In the above examples, port 4789 is used for User Datagram Protocol (UDP).

#When deployments are using the SDN, the pod network is accessed via a service proxy, unless it is accessing the registry
#from the same node the registry is deployed on.

#OpenShift internal DNS cannot be received over SDN. Depending on the detected values of openshift_facts, or if the
#openshift_ip and openshift_public_ip values are overridden, it will be the computed value of openshift_ip. For non-cloud
#deployments, this will default to the IP address associated with the default route on the master host. For cloud
#deployments, it will default to the IP address associated with the first internal interface as defined by the cloud
#metadata.

#The master host uses port 10250 to reach the nodes and does not go over SDN. It depends on the target host of the
#deployment and uses the computed values of openshift_hostname and openshift_public_hostname.


