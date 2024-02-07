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
    - Azure CR
    - Github PAT for git SCM
    - sample credentials file 

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

		# Create AKS cluster with two worker nodes
			az aks create --resource-group aks_deploy --name aksdeployk8s --node-count 2 --generate-ssh-keys

		# Create Azure Container Registry
			az acr create --resource-group aks_deploy --name aksdeploypoc --sku Standard --location centralus

        #Update azure container registry credential in jenkins

		#Providing required permission for downloading Docker image from ACR into AKS Cluster
			az aks update -n aksdeployk8s -g aks_deploy --attach-acr aksdeploypoc

        #Get aks credentials in  /var/lib/jenkins/.kube/config
			az aks get-credentials --resource-group aks_deploy --name aksdeployk8s --overwrite-existing
			
		#Verify aks credentials in /var/lib/jenkins/.kube/config
			cat /var/lib/jenkins/.kube/config

		#Create k8s namespace
			kubectl create namespace mcr-app-deployment

        #Azure cli logged in accounts list
			az account list
		
		#kubectl commands for debug or info
			kubectl get nodes  										//Check nodes
			kubectl config get-contexts 							//Get k8s contexts
            kubectl get namespace                                   //Get list of namespaces
			kubectl get deployments --all-namespaces=true			//Get deployments in all namespaces
			kubectl get deployments --namespace mcr-app-deployment	//Get deployments in specific namespace
		
--------------------------------------------------------------------------------------------------------------------------------

#Use Jenkins pipeline build to deploy to k8s cluster
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

#Stop ngrok terminal CNTRL+C

#Stop Jenkins service
	sudo service jenkins stop