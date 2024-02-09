# This project helps to do the below workflow:

1. Code push to GitHub.

2. Trigger pipeline in Jenkins.

3. Create an Azure container registry (ACR) and AKS cluster in an existing resource group.

4. Build a docker image and push it to DockerHub and Azure container registry.

5. Deploy to azure AKS cluster.


# Pre-requisites
1. Access to this Github repo ready with required files and k8s manifest file.

2. Azure account with an active subscription.

3. Below resources in Azure are required.
1. Azure resource group.
2. Azure service principal with a "Contributor" role for that resource group.

Click [here](#azure-pre-requistes) to create both new.

3. Jenkins setup with below-installed plugins, credentials, and tools.
1. **Plugins:**
- GitHub Branch Source Plugin
- Kuberenetes CLI Plugin
- Docker Pipeline
- Azure credentials.

2. **Credentials:** Add the below credentials in Jenkins credential manager.
- DockerHub registry.
- Azure service principal. [help](#jenkins-azure-credentials)
- GitHub Personal access token (PAT) to trigger Jenkins pipeline on GitHub commit (only for private GitHub repos)
- Sample credentials file with the text "Hello"

3. **Tools:** Install the below tools in the Jenkins machine by logging in as "jenkins" user. (Enter password if asked)
```
sudo su -s /bin/bash jenkins
```
- docker
- helm
- kubectl
- Azure CLI

3. Create a new multibranch pipeline in Jenkins add the source as GitHub repo URL and set auto trigger for all branches. (Use GitHub PAT if repo is private)


# Steps to set up the project:

1. Verify Jenkins is running or else start it. (Options: start, stop, restart)
```
sudo service jenkins start
```

---
<details>
<summary>Expand if you are running Jenkins in a local port.</summary>

Install "ngrok" and run the below command with your Jenkins port to get the public URL for Jenkins
```
ngrok port 8080
```
- Copy the ngrok URL from the terminal, open it in the browser, and log in.
- This will be our public Jenkins URL.
</details>

---


2. Use Jenkins URL in
1. Set up Jenkins URL in GitHub repository webhook.
2. **Optional:** Set up Jenkins URL in VScode for pipeline lint. (With Jenkins pipeline lint plugin)


> [!IMPORTANT] Make sure before running pipeline the file "create_azure_setup.sh" has only the below steps uncommented.
> - Create an AKS cluster with 2 nodes.
> - Create Azure container registry (ACR).
> - Link ACR to AKS.
> - Create a namespace in the AKS cluster.

# Run Jenkins pipeline.

1. View the pipeline log. The below stages should be run successfully.
- Azure resource creation.
- Build and push the image to dockerHub.
- Build and push images to Azure CR.
- Deploy to Kubernetes.

2. The app will be installed in the cluster and accessed using the External IP of the cluster.
- **In the Jenkins machine log in as "jenkins" user.** (Refer to section "Pre-requisites" 2.3 )
- Get the external IP of the cluster.
```
kubectl get service store-front
```
- Access the deployed app using the IP address.

# Cleanup resources.
1. Clean up resources in Azure by deleting the Azure resource group.
```
az group delete --name aks_deploy --yes --no-wait
```
2. Clear and log out from all resources.
- Delete AKS credentials
```
rm -rf /var/lib/jenkins/.kube/
```
- Remove **kubectl** contexts.
```
kubectl config unset current-context
```
- Logout from Azure.
```
az logout
```
- (Optional) Stop ngrok terminal CNTRL+C.

- Stop Jenkins service.
```
sudo service jenkins stop
```


# Debug commands in Jenkins machine:
- AKS credentials for kubectl will be stored in /var/lib/jenkins/.kube/config

- Azure List all logged accounts.
```
az account list
```

- **kubectl** commands for debug or info
- List nodes
```
kubectl get nodes
```
- Get k8s contexts
```
kubectl config get-contexts
```
- Get the list of namespaces
```
kubectl get namespace
```
- Get deployments in all namespaces
```
kubectl get deployments --all-namespaces=true
```
- Get deployments in specific namespace
```
kubectl get deployments --namespace mcr-app-deployment
```


# Azure pre-requistes

> [!NOTE] Be cautious about creating resources in Azure and delete all resources after use.

Create an Azure resource group and Azure service principal with a "Contributor" role for that resource group.

1. Run the below command, follow the instructions, and log in to your Azure account.
```
az login --use-device-code
```
2. Create a Resource Group.
```
az group create --location centralus --name <resource_group_name>
```
3. Create an Azure service principal using your subscription ID with a "Contributor" role in the created Azure resource group. *** Store the output somewhere safe***.
```
az ad sp create-for-rbac --name aksdeployServicePrincipal --role Contributor --scopes /subscriptions/<subscriptionID>/resourceGroups/<resource_group_name>
```

# Jenkins-Azure credentials
Create Azure service principal in Jenkins credentials.

- Ensure Azure credentials plugin-in is installed in Jenkins.
- While creating select **"Kind"** as **"Azure Service Principal"**.
- Fill in Azure service principal details.
| Field | Value |
| - | - |
| Subscription ID | Your Azure subscription ID |
| Client ID | appId |
| Client Secred | password |
| Tenant ID | tenant |