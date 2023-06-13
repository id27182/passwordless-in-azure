# Passwordless in azure

This repository contains terraform code samples for demonstrating passwordless options in azure. Each sample is a working terraform module, which deploys described infrastructure - review the variables and try it!

Requirements: 
- az cli (v2.41 or newer)
- terraform (v1.4.5 or newer) 
- kubectl (v1.23.1 or newer)

#### 1-web-app-with-passwords
"Initial state" of the infrastructure: Linux web app and a storage account. Web app has storage account key the application config - application supposed to read that key from the environment variable and use to authorise on the storage account. 

Usage: 
```
cd ./1-web-app-with-passwords
terraform init 
terraform apply 
```

#### 2-web-app-with-managed-identity
Updated version of the initial infrastructure - web app uses managed identity instead of storage account key to authorise on the storage account. 

Usage: 
```
cd ./2-web-app-with-managed-identity
terraform init 
terraform apply 
```

#### 3-aks-kublet-identity
Example of how can we use kubelet identity to authorise the workload on Azure resources. 

Usage: 
```
cd ./3-aks-kublet-identity
terraform init 
terraform apply 
```

#### 4-aks-workload-identity
Example of how to deploy Azure Workload Identity and use it to authorise workload, deployed to AKS cluster, on Azure resources. 

Usage: 
```
cd ./4-aks-workload-identity

# Deploy infrastructure:
terraform init 
terraform apply 

# Connect to Kubernetes cluster
az aks get-credentials -n <aks-cluster-name> -g <aks-rg>

# Deploy sample workload
kubectl apply -f ./kubernetes/service-account.yaml
kubectl apply -f ./kubernetes/pod.yaml
```
