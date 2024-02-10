#!/bin/sh

# Credits: DevOps coach
# https://youtu.be/fdzuMGSIz8A
# https://www.coachdevops.com/2023/05/how-to-deploy-springboot-microservices.html
# This is the shell script for creating AKS cluster, ACR Repo and a namespace

AKS_REGION=centralus
AKS_RESOURCE_GROUP=test_deploy
AKS_CLUSTER=testk8s	# Azure Kubernetes Services cluster name
ACR_NAME=tesracr   	# Azure Container Registry name
AKS_CLUSTER_NAMESPACE=mcr-app-deployment # k8s cluster namespace name

echo $AKS_RESOURCE_GROUP, $AKS_REGION, $AKS_CLUSTER, $ACR_NAME

# Create Resource Group
#az group create --location ${AKS_REGION} --name ${AKS_RESOURCE_GROUP}		  //Uncomment if resource group is not created.

# Create AKS cluster with two worker nodes
az aks create --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_CLUSTER} --node-count 2 --generate-ssh-keys 

# Create Azure Container Registry
az acr create --resource-group ${AKS_RESOURCE_GROUP} --name ${ACR_NAME} --sku Standard --location ${AKS_REGION}

#Providing required permission for downloading Docker image from ACR into AKS Cluster
az aks update -n ${AKS_CLUSTER} -g ${AKS_RESOURCE_GROUP} --attach-acr ${ACR_NAME}

#Get aks credentials in  /var/lib/jenkins/.kube/config
az aks get-credentials --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_CLUSTER} --overwrite-existing

#Create k8s namespace
kubectl create namespace ${AKS_CLUSTER_NAMESPACE}