# Quick-Kubernetes-Kafka-Demo

## SETUP
This stuff needs to be done before you begin the demo

Clear out your ./kube/conf file so there will be no conflicts

### Add EdgeLB Repos and Deploy EdgeLB
We will use EdgeLB to access numerous services on DC/OS including Kubernetes API Server, Grafana, and Prometheus
`dcos package repo add --index=0 edgelb https://downloads.mesosphere.com/edgelb/v1.2.3/assets/stub-universe-edgelb.json`
    
`dcos package repo add --index=0 edgelb-pool https://downloads.mesosphere.com/edgelb-pool/v1.2.3/assets/stub-universe-edgelb-pool.json`
    
`dcos package install --yes edgelb`

### PRE-DEPLOY SERVICES AND CLIs
there are numerous services that need to be pre-installed for the demo to work.  Run them individually to ensure that they al deploy properly.

`dcos package install --yes dcos-enterprise-cli`

`dcos package install --yes kafka`

`dcos package install --yes prometheus`

`dcos package install --yes grafana`
    

### PREDEPLOY MKE & K8S-CLUSTER-1
There are numerous permissions sets that need to be created to get the demo to work,  Run these indivudually to ensure that they all run correctly:

`bash mke_AccountsPermissions.sh`
    
`bash k8sCluster_AccountsPermissions.sh k8s-cluster-1`
    
`bash k8sCluster_AccountsPermissions.sh k8s-cluster-2`
    
`bash k8sCluster_AccountsPermissions.sh k8s-cluster-3`
    
`dcos package install --yes kubernetes --options=mke-options.json`
    
 Install Kubernetes cluster "k8s-cluster-1" with a few Kubelets and atleast 1 public kubelet

### DEPLOY EDGELB POOL
This Pool will be used to provide outside connectivity to DC/OS Services     

`dcos edgelb create edgelb-proxy.json`

verify that everything is where you want it:
    
`http://<Public-Node-IP>:9090/haproxy?stats`(Bookmark this page)

### Prepare "K8S-CLUSTER-1"
```
dcos kubernetes cluster kubeconfig \
    --insecure-skip-tls-verify \
    --context-name=k8s-cluster-1 \
    --cluster-name=k8s-cluster-1 \
    --apiserver-url=https://<EDGELB-POOL-PUBLIC-IP>:6001
```
kubectl create namespace sock-shop
kubectl apply -f complete-demo.yaml

CONNECT PROMETHEUS to GRAFANA and get the Kafka DC/OS Dashboard from Grafana.com
    (Bookmark the Grafana Dashboard Page)






All of the above is pre-setup work
-------------------------------------------------
Below is Live Demo Stuff



## SHOWTIME

Start by giving them a quick tour of DC/OS (Data Services, CICD, Kubernetes, etc.)
Talk about "Why Kubernetes With DC/OS"

DEPLOY NEW KUBERNETES CLUSTER via GUI
    Create "k8s-cluster-2" from the GUI with defaults (using "k8s-cluster-2" for service, service name, and /sa for secret)
    DEPLOY

Deploy Kubernetes Cluster 3 via CLI (automation)
    `dcos package install kubernetes-cluster --options=k8s-cluster-3`

Check Back in on Cluster 2 with CLI
    `dcos kubernetes cluster debug plan status deploy --cluster-name=k8s-cluster-2`

While it finishes deploying, create your Kafka Topics
    `dcos kafka topic create transactions`
    `dcos kafka topic list`

Confirm the cluster is done deploying
    `dcos kubernetes cluster debug plan status deploy --cluster-name=k8s-cluster-2`

Create Kubectl Connection to "k8s-cluster-2"
    ```
    dcos kubernetes cluster kubeconfig \
        --insecure-skip-tls-verify \
        --context-name=k8s-cluster-2 \
        --cluster-name=k8s-cluster-2 \
        --apiserver-url=https://<EDGELB-POOL-PUBLIC-IP>:6002
    ```

Verify kubectl connection
    `kubectl get nodes`

DEPLOY KAFKA PRODUCER ON K8s-cluster-2
    `kubectl apply -f kafka-demo-generator.yaml`
    `kubectl get deployments`
    `kubectl get pods`
VERIFY Writing to KAFKA
    `dcos kafka topic offsets transactions`

DEPLOY CONSUMER on k8s-cluster-2 (Copy the Pod ID)
    `kubectl apply -f transaction-consumer.yaml`
    `kubectl get deployments`
    `kubectl get pods`
VERIFY READING DATA FROM KAFKA TOPIC
    `kubectl logs <PASTE-POD-ID-FROM-ABOVE> | more`

# Recapwhat we did...
and as easy as it was to stand up, it is just as easy to tear down :-)
