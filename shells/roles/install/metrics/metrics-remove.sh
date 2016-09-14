
oc project openshift-infra

oc delete all --all

oc delete secrets hawkular-cassandra-certificate \
hawkular-cassandra-secrets hawkular-metrics-account \
hawkular-metrics-certificate hawkular-metrics-secrets \
heapster-secrets metrics-deployer

oc delete template hawkular-cassandra-node-emptydir \
hawkular-cassandra-node-pv hawkular-cassandra-services \
hawkular-heapster hawkular-metrics hawkular-support

oc delete sa hawkular cassandra heapster metrics-deployer

