pipeline {
    agent any

    environment {
                AKS_REGION='centralus'
                ACR_NAME = 'testacr7'
                DOCKER_IMAGE_NAME = 'testimage'
                AKS_RESOURCE_GROUP='test_deploy'
                AKS_CLUSTER='testk8s'
                AKS_CLUSTER_NAMESPACE='mcr-app-deployment'  
            }

    stages {
        stage('Build and push image to Azure CR') {
                steps {
                    withCredentials([azureServicePrincipal('aksdeployServicePrincipal')]) {
                        script {
                            sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                            sh 'az account list'

                            // Build Docker image 
                            sh 'docker build -t testimage .'
                            // Tag Docker image name
                            sh 'docker tag testimage testacr7.azurecr.io/testimage:latest'
                            // Push Docker image to Azure Container Registry
                            sh 'docker push testacr7.azurecr.io/testimage:latest'

                            // // Build Docker image
                            // sh 'docker build -t ${DOCKER_IMAGE_NAME} .'

                            // // Tag Docker image name
                            // sh 'docker tag ${DOCKER_IMAGE_NAME} ${ACR_NAME}.azurecr.io/${DOCKER_IMAGE_NAME}:latest'

                            // // Push Docker image to Azure Container Registry
                            // sh 'docker push ${ACR_NAME}.azurecr.io/${DOCKER_IMAGE_NAME}:latest'
                        }
                    }
                }
            }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'az aks get-credentials --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_CLUSTER} --overwrite-existing'
                sh 'kubectl create namespace ${AKS_CLUSTER_NAMESPACE}'
                sh 'kubectl apply -f aks-store-quickstart.yaml'
            }
        }
    }

    post {
        always {            
            // Clean up Docker images, containers and workspace.
            script {
                sh 'docker rmi -f $(docker images -q)'
                sh 'docker system prune -f'
                deleteDir()
            }   
        }
        success {
            echo 'This runs only if the pipeline is successful'
        }
        failure {
            echo 'This runs only if the pipeline fails'
        }
    }
}
