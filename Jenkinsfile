pipeline {
    agent any

    environment {
                ACR_NAME = 'tesracr' //'testacr'
                DOCKER_IMAGE_NAME = 'testimage'  
            }

    stages {
        stage('Build and push image to Azure CR') {
                steps {
                    withCredentials([azureServicePrincipal('aksdeployServicePrincipal')]) {
                        script {
                            //sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                            sh 'az account list'

                            // Build Docker image 
                            //sh 'docker build -t testimage .'
                            sh 'docker build -t ${DOCKER_IMAGE_NAME} .'

                            // Tag Docker image name
                            //sh 'docker tag ${ACR_NAME} testacr.azurecr.io/testimage:latest'
                            sh 'docker tag ${DOCKER_IMAGE_NAME} ${ACR_NAME}.azurecr.io/${DOCKER_IMAGE_NAME}:latest'

                            // Push Docker image to Azure Container Registry
                            //sh 'docker push testacr.azurecr.io/testimage:latest'
                            sh 'docker push ${ACR_NAME}.azurecr.io/${DOCKER_IMAGE_NAME}:latest'
                        }
                    }
                }
            }

        // stage('Deploy to Kubernetes') {
        //     steps {
        //         sh 'kubectl apply -f aks-store-quickstart.yaml'
        //     }
        // }
    }

    post {
        always {            
            // Clean up Docker images, containers and workspace.
            script {
                //sh 'docker rmi -f $(docker images -q)'
                //sh 'docker system prune -f'
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
