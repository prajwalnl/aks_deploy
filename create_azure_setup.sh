#!/bin/sh

# This is the shell script for creating AKS cluster, ACR Repo and a namespace

AKS_RESOURCE_GROUP=aks_deploy
AKS_REGION=centralus
AKS_CLUSTER=aksdeployk8s	# Set Cluster Name
ACR_NAME=aksdeploypoc   	# set ACR name

echo $AKS_RESOURCE_GROUP, $AKS_REGION, $AKS_CLUSTER, $ACR_NAME

# Create Resource Group
#az group create --location ${AKS_REGION} --name ${AKS_RESOURCE_GROUP}		

# Create AKS cluster with two worker nodes
az aks create --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_CLUSTER} --node-count 2 --generate-ssh-keys 

# Create Azure Container Registry
az acr create --resource-group ${AKS_RESOURCE_GROUP} --name ${ACR_NAME} --sku Standard --location ${AKS_REGION}

#Providing required permission for downloading Docker image from ACR into AKS Cluster
az aks update -n ${AKS_CLUSTER} -g ${AKS_RESOURCE_GROUP} --attach-acr ${ACR_NAME}

#Get aks credentials in  /var/lib/jenkins/.kube/config
az aks get-credentials --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_CLUSTER} --overwrite-existing

#Create k8s namespace
kubectl create namespace mcr-app-deployment