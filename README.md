# This project helps to do the below workflow:

1. Code push to GitHub.

2. Trigger pipeline in Jenkins.

3. Create Azure container registry (ACR) and AKS cluster in a existing resource group.

4. Build docker image and push to DockerHub and Azure container registry.

5. Deploy to azure AKS cluster.


# Pre-requistes
1. Access to this Github repo ready with required files and k8s manifest file.

2. Azure account with a active subscription.

3. Below resources in Azure.
	1. Azure resource group.
	2. Azure service principal with contirbutor role for that resource group.
	
	Click [here](#azure-pre-requistes) to create both new.

3. Jenkins setup with below installed plugins, credentials and tools.
	1. **Plugins:**
		- GitHub Branch Source Plugin
		- Kuberenetes CLI Plugin 
		- Docker Pipeline
		- Azure credentials.

	2. **Credentials:** Add below credentials in Jenkins credential manager.
		- DockerHub registry.
		- Azure service principal. [help](#jenkins-azure-credentials)
		- GitHub Personal access token (PAT) to trigger jenkins pipeline on github commit (only for private GitHub repo's)
		- Sample credentials file with text "Hello"

	3. **Tools:** Install below tools in jenkins machine by loging in as jenkins user. (Enter password if asked)
		```
		sudo su -s /bin/bash jenkins
		```
		- docker
		- helm
		- kubectl
		- Azure CLI

3. Create a new multibranch pipeline in Jenkins add source as GitHub repo URL and setup auto trigger for all branches. (Use GitHub PAT if repo is private)


# Steps to setup the project:

1. Verify jenkins is running or else start it. (Options: start,stop,restart)
	```
	sudo service jenkins start
	```

---
<details>
<summary>Expand if you are running Jenkins in local port.</summary>

Install "ngrok" and run below command with your jenkins port to get public URL for Jenkins
```
ngrok port 8080
```
- Copy the ngrok URL from terminal and open it in browser and login.
- This will be our public Jenkins URL.
</details>	

---
	

2. Use Jenkins URL in
	1. Setup Jenkins URL in GitHub repository webhook.
	2. **Optional:** Setup Jenkins URL in VScode for pipeline lint. (With Jenkins pipeline lint plugin)


> [!IMPORTANT] Make sure before running pipeline the file "create_azure_setup.sh" has only the below steps uncommented.
> - Create AKS cluster with 2 nodes.
> - Create Azure container registry (ACR).
> - Link ACR to AKS.
> - Create a namespace in AKS cluster.

# Run Jenkins pipeline.

1. View pipeline log. Below stages should be run successfully.
	- Azure resource creation.
	- Build and push image to dockerHub.
	- Build and push image to Azure CR.
	- Deploy to Kubernetes.

2. App will be installed in cluster and can be accessed using External IP of cluster.
	- **In Jenkins machine login as "jenkins" user.** (Refer section "Pre-requistes" 2.3 )
		- Get external IP of cluster.
			```
			kubectl get service store-front
			```
		- Access the deployed app using the IP address.

# Cleanup resources.
1. Cleanup resources in azure by deleting azure resource group.
	```
	az group delete --name aks_deploy --yes --no-wait
	```
2. Clear and logout from all resources.
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
	- Get list of namespaces
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

Create a azure resource group and azure service principal with "Contributor" role for that resource group.

1. Run below command and follow instructions and login to your azure account.
```
az login --use-device-code 
```
2. Create Resource Group.
```
az group create --location centralus --name <resource_group_name>
```
3. Create Azure service principal using your subscription ID with Contributor role in created azure resource group store the output somewhere safe.
```
az ad sp create-for-rbac --name aksdeployServicePrincipal --role Contributor --scopes /subscriptions/<subscriptionID>/resourceGroups/<resource_group_name>
```



# Jenkins-Azure credentials
Create Azure service principal in Jenkins credentials.

- Ensure Azure credentials plugin-in is installed in jenkins. 
- While creating select **"Kind"** as **"Azure Service Principal"**.
- Fill credentials details from output of previous command
	| Field | Value |
	| - | - |
	| Subscription ID |	Your Azure subscription ID |
	| Client ID | appId |
	| Client Secred | password |
	| Tenant ID | tenant |