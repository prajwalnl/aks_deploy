#Github repo ready with dockerfile and k8s manifest file

#Open ubuntu

#Install jenkins in ubuntu

#Start jenkins server
	sudo service jenkins start        (Options: stop,restart )
	
#Setup and login into jenkins using chrome at port 8080

#Install Jenkins plugins
    - GitHub Branch Source Plugin
    - Pipeline: GitHub Groovy Libraries
    - Kuberenetes CLI Plugin 
    - Docker Pipeline

#Add credentials (username and password for docker,acr??,
    - Docker
    - Azure service principal
    - Github PAT for git SCM 	(only for private repo's)
    - sample credentials file with text "Hello"

#Create a new multibranch pipeline 
	add source as github repo url and setup scm
	
#Start ngrok tunnel of jenkins
	ngrok port 8080
	
#Copy the ngrok URL from terminal and open it in win chrome and login

#Setup Jenkins URL in vscode

#Setup Jenkins URL in github repo webhook.

#In ubuntu login as jenkins user
	sudo su -s /bin/bash jenkins
	
	Enter password
	
#Verify docker, helm, kubectl and azure cli installation if not install.

#As jenkins user setup azure resource group, k8s cluster and container registry.
		#login to azure through cli
			az login --use-device-code    // and login through browser
		
		# Create Resource Group
			az group create --location centralus --name aks_deploy

		#Create Azure service principal with Contributor role in created azure resource group
			az ad sp create-for-rbac --name aksdeployServicePrincipal --role Contributor --scopes /subscriptions/<subscriptionID>/resourceGroups/aks_deploy

		#Update Azure service principal in Jenkins credentials. (use type azure service principal)
			#Get from output of previous command
				Subscription ID: 	Your Azure subscription ID.
				Client ID: 			"appId"
				Client Secred: 		"password"
				Tenant ID: 			"tenant"
			
#Run "create-azure-resource" brannh build in Jenkins to create following resources.
	- AKS cluster with 2 nodes.
	- Azure container registry.
	- Link ACR to AKS.
	- Create a namespace in k8s cluster.

		#Verify aks credentials in /var/lib/jenkins/.kube/config
			cat /var/lib/jenkins/.kube/config

        #Azure cli logged in accounts list
			az account list
		
		#kubectl commands for debug or info
			kubectl get nodes  										//Check nodes
			kubectl config get-contexts 							//Get k8s contexts
            kubectl get namespace                                   //Get list of namespaces
			kubectl get deployments --all-namespaces=true			//Get deployments in all namespaces
			kubectl get deployments --namespace mcr-app-deployment	//Get deployments in specific namespace
		
--------------------------------------------------------------------------------------------------------------------------------

#Use Jenkins 'main' pipeline to run main workflow with below stages
	-			<list stages>
    kubectl apply -f aks-store-quickstart.yaml
		
--------------------------------------------------------------------------------------------------------------------------------
#In Ubuntu jenkins user, Get external IP to access app in k8s cluster
	kubectl get service store-front           // to watch continuesly add flag:  --watch
	
#Access the app through external IP using a browser

#Cleanup Resources
	az group delete --name aks_deploy --yes --no-wait
	
#Logout from resources
		kubectl config unset current-context
		az logout
		
#Verify /var/lib/jenkins/.kube/config file is deleted
    rm -rf /var/lib/jenkins/.kube/

#Stop ngrok terminal CNTRL+C

#Stop Jenkins service
	sudo service jenkins stop