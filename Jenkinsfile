pipeline {
    agent any

    environment {
                AKS_REGION='centralus'
                ACR_NAME = 'testacr7'
                DOCKER_IMAGE_NAME = 'testsbimage'
                AKS_RESOURCE_GROUP='test_deploy'
                AKS_CLUSTER='testk8s'
                AKS_CLUSTER_NAMESPACE='mcr-app-deployment'
                DEMO_DOCKER_IMAGE_NAME='demodockerimage'
            }

    stages {
        stage('Azure login.') {
                steps {
                    withCredentials([azureServicePrincipal('aksdeployServicePrincipal')]) {
                        script {
                            // Azure login
                            sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                            // Login to azure ACR
                            sh 'az acr login --name ${ACR_NAME}'
                        }
                    }
                }
            }

        stage('Maven build') {
            agent {
                docker {
                    image 'maven:3.3-jdk-8'
                }
            }
            steps {
                // Build springboot app jar
                sh 'ls'
                sh 'mvn --version' //clean install'
                sh 'ls'
            }
        }

        stage('SpringbootApp: docker push to ACR') {
            steps {
                // Build Docker image
                sh 'docker build -t ${DOCKER_IMAGE_NAME} .'
                // Tag Docker image name
                sh 'docker tag ${DOCKER_IMAGE_NAME} ${ACR_NAME}.azurecr.io/${DOCKER_IMAGE_NAME}:latest'
                // Push Docker image to Azure Container Registry
                sh 'docker push ${ACR_NAME}.azurecr.io/${DOCKER_IMAGE_NAME}:latest'
            }
        }

        //SpringbootApp deploy
        // stage ('Helm Deploy') {
        //   steps {
        //     script {
        //         sh "helm upgrade first --install mychart --namespace helm-deployment --set image.tag=$BUILD_NUMBER"
        //         }
        //     }
        // }


        // stage('Deploy to Kubernetes') {
        //     steps {
        //         sh 'az aks get-credentials --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_CLUSTER} --overwrite-existing'
        //         sh 'kubectl create namespace ${AKS_CLUSTER_NAMESPACE}'
        //         sh 'kubectl apply -f aks-store-quickstart.yaml'
        //     }
        // }

        // stage('Demo docker push to ACR') {
        //     steps {
        //         // Build Docker image
        //         sh 'docker build -t ${DEMO_DOCKER_IMAGE_NAME} -f Dockerfile-demo .'
        //         // Tag Docker image name
        //         sh 'docker tag ${DEMO_DOCKER_IMAGE_NAME} ${ACR_NAME}.azurecr.io/${DEMO_DOCKER_IMAGE_NAME}:latest'
        //         // Push Docker image to Azure Container Registry
        //         sh 'docker push ${ACR_NAME}.azurecr.io/${DEMO_DOCKER_IMAGE_NAME}:latest'
        //     }
        // }
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
