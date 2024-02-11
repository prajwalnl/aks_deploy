pipeline {
    tools {
        maven 'Maven3'
    }

    agent any

    environment {
                AKS_REGION='centralus'
                ACR_NAME = 'testacr7'
                DOCKER_IMAGE_NAME = 'testsbimage'
                AKS_RESOURCE_GROUP='test_deploy'
                AKS_CLUSTER='testk8s'
                AKS_CLUSTER_NAMESPACE='helm-deployment'
            }

    stages {
        stage('Azure login') {
                steps {
                    withCredentials([azureServicePrincipal('aksdeployServicePrincipal')]) {
                        script {
                            sh 'ls -a /var/lib/jenkins/'
                            sh 'rm -rf /var/lib/jenkins/.kube/'
                            sh 'ls -a /var/lib/jenkins/'
                            sh 'az logout'
                            // Azure login
                            sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                            // Login to azure ACR
                            //sh 'az acr login --name ${ACR_NAME}'
                            sh 'az aks get-credentials --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_CLUSTER} --overwrite-existing'
                        }
                    }
                }
            }

        // stage('Maven build') {
        //     steps {
        //         // Build springboot app jar
        //         sh 'mvn clean install'
        //     }
        // }

        // stage('SpringbootApp: docker push to ACR') {
        //     steps {
        //         // Build Docker image
        //         sh 'docker build -t ${DOCKER_IMAGE_NAME} .'
        //         // Tag Docker image name
        //         sh 'docker tag ${DOCKER_IMAGE_NAME} ${ACR_NAME}.azurecr.io/${DOCKER_IMAGE_NAME}:latest'
        //         // Push Docker image to Azure Container Registry
        //         sh 'docker push ${ACR_NAME}.azurecr.io/${DOCKER_IMAGE_NAME}:latest'
        //     }
        // }

        //SpringbootApp deploy
        stage ('Helm Deploy') {
          steps {
            script {               
                def namespaceExists = sh(script: "kubectl get namespace ${AKS_CLUSTER_NAMESPACE}", returnStatus: true) == 0
                if (!namespaceExists) {
                    echo "Namespace ${AKS_CLUSTER_NAMESPACE} does not exists."
                } else {
                    echo "Namespace ${AKS_CLUSTER_NAMESPACE} already exists."
                    sh 'kubectl delete namespace ${AKS_CLUSTER_NAMESPACE} --wait=true --timeout=300s'
                }
                sh "kubectl create namespace ${AKS_CLUSTER_NAMESPACE}"
                sh "helm upgrade first --install mychart --namespace ${AKS_CLUSTER_NAMESPACE}" //--set image.tag=$BUILD_NUMBER"
                }
            }
        }

        // stage('kubectl deploy') {
        //     steps {
        //         sh 'az aks get-credentials --resource-group ${AKS_RESOURCE_GROUP} --name ${AKS_CLUSTER} --overwrite-existing'
        //         sh 'kubectl create namespace ${AKS_CLUSTER_NAMESPACE}'
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
                //sh 'rm -rf /var/lib/jenkins/.kube/'
                //sh 'az logout'
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
