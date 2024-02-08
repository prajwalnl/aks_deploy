#!/bin/sh

# This is the shell script for creating AKS cluster, ACR Repo and a namespace

AKS_RESOURCE_GROUP=aks_deploy
AKS_REGION=centralus
AKS_CLUSTER=aksdeployk8s	# Set Cluster Name
ACR_NAME=aksdeploypoc   	# set ACR name

echo $AKS_RESOURCE_GROUP, $AKS_REGION, $AKS_CLUSTER, $ACR_NAME