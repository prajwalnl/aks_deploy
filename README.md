# Jenkins, Helm, ACR, AKS
This project helps to do the below workflow:

1. Trigger pipeline in Jenkins on code push to github.

2. Build a docker image and push it to Azure container registry.

3. Deploy to azure AKS cluster.

# Pre-requisites
1. Access to this Github repo with required files.

2. Azure account with an active subscription.

3. Jenkins setup with below-installed plugins, credentials, and tools.
	1. **Credentials:** Add the below credentials in Jenkins credential manager.
		- GitHub Personal access token (PAT) to trigger Jenkins pipeline on GitHub commit (only for private GitHub repos)

	2. **Plugins:**
		- GitHub Branch Source Plugin
		- Kuberenetes CLI Plugin
		- Docker Pipeline
		- Azure credentials.

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
	<details>
	<summary>Expand if you are running Jenkins in a local port.</summary>

	Install "ngrok" and run the below command with your Jenkins port to get the public URL for Jenkins
	```
	ngrok port 8080
	```
	- Copy the ngrok URL from the terminal, open it in the browser, and log in.
	- This will be our public Jenkins URL.
	</details>

2. Use Jenkins URL in
	1. Set up Jenkins URL in GitHub repository webhook.
	2. **Optional:** Set up Jenkins URL in VScode for pipeline lint. (With Jenkins pipeline lint plugin)

3. Add Maven in Jenkins.
	- Go to "<jenkins_base_url>/manage/configureTools" --> Maven installations.
	- Add Maven with variable name **"Maven3"**.

4. Create Azure resources and Azure service principal.
	Click [here](#azure-pre-requistes) to create new.

5. Create Azure credentials in Jenkins. [help](#jenkins-azure-credentials)

6. Update "Jenkinsfile" with created resources names.


# Run Jenkins pipeline.
1. Commit to GitHub or manually start the pipeline.

2. View the pipeline log. The below stages should be run successfully.
	- Build and push images to Azure CR.
	- Deploy to Kubernetes.

3. The app will be installed in the cluster and can be accessed using the External IP of the cluster.

4. **In Jenkins machine**
	- Login as "jenkins" user.
		```
		sudo su -s /bin/bash jenkins
		```
	- Get the external IP of the cluster.
		```
		kubectl get service store-front
		```
	- Access the deployed app using the IP address.

# Cleanup resources.
1. Clean up resources in Azure by deleting the Azure resource group.
	```
	az group delete --name <resource_group_name> --yes --no-wait
	```
2. Clear and log out from all resources.
	- Delete AKS credentials
		```
		rm -rf /var/lib/jenkins/.kube
		```
	- Remove **kubectl** contexts.
		```
		kubectl config unset current-context
		```
	- Delete Azure service principal.
		```
		az ad app delete --id <your-service-principal-app-id>
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

# Debug commands in Jenkins machine
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
		kubectl get deployments --namespace <k8s-namespace-name>
		```


# Azure pre-requistes

> [!WARNING] 
> Be cautious about creating resources in Azure and delete all resources after use.

Create an Azure resources using azure CLI in different machine.

1. Run the below commands, follow the instructions, and log in to your Azure account.
	```
	az login --use-device-code
	```
2. Create a Resource Group.
	```
	az group create --location centralus --name <aks_resource_group>
	```
3. Create Azure Container Registry.
	```
	az acr create --resource-group <aks_resource_group> --name <acr_name> --sku Standard --location centralus
	```
4. Create AKS cluster with two worker nodes and attach Azure container registry.
	```
	az aks create --resource-group <aks_resource_group> --name <aks_name> --node-count 2 --generate-ssh-keys --attach-acr <acr_name>
	```
5. Create an Azure service principal using your subscription ID with a "Contributor" role in the created Azure resource group. ***Store the output somewhere safe***.
	```
	az ad sp create-for-rbac --name <servicePrincipalName> --role Contributor --scopes /subscriptions/<subscriptionID>/resourceGroups/<aks_resource_group>
	```

# Jenkins-Azure credentials
Create Azure credentials in Jenkins.

- Ensure Azure credentials plugin is installed in Jenkins.
- While creating select **"Kind"** as **"Azure Service Principal"**.
- Fill in Azure service principal details.
	| Field | Value |
	| - | - |
	| Subscription ID | Your Azure subscription ID |
	| Client ID | appId |
	| Client Secred | password |
	| Tenant ID | tenant |