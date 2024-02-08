pipeline {
    agent any

    environment {
                helloWorld = "Hello World!"
                ACR_NAME = 'aksdeploypoc'
                DOCKER_IMAGE_NAME = 'aksdeploypocimage'  
            }

    stages {
        stage('Azure Login and List Accounts') {
                steps {
                    withCredentials([azureServicePrincipal('aksdeployServicePrincipal')]) {
                        script {
                            //sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                            //sh 'az account list'
                            
                            // Log in to Azure Container Registry
                            //sh "az acr login --name $ACR_NAME"

                            // Build Docker image (replace with your Docker build command)
                            sh 'chmod a+x create_azure_setup.sh'
                            sh './create_azure_setup.sh'
                            sh "docker build -t $ACR_NAME.azurecr.io/$DOCKER_IMAGE_NAME:latest ."

                            // Push Docker image to Azure Container Registry
                            sh "docker push $ACR_NAME.azurecr.io/$DOCKER_IMAGE_NAME:latest"
                        }
                    }
                }
            }

        // stage('Build and push image to ACR') {
        //     environment {
        //         acrRegistryName = "aksdeploypoc"
        //         registryURL = "https://aksdeploypoc.azurecr.io"
        //         registryCredential = 'acr-cred'
        //     }
        //     steps {
        //         script {
        //             acrImage = docker.build acrRegistryName + ":$BUILD_NUMBER"
        //             docker.withRegistry( registryURL, registryCredential ) {   // Authenticate with ACR
        //                 acrImage.push()         // Push Docker image to ACR
        //             }
        //         }
        //     }
        // }

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        // stage('No Image and build downloadable artifact') {
        //     steps {
        //         echo 'Executing Job without Image'
        //         sh 'echo ${helloWorld}'
        //         sh 'cat /etc/os-release'
        //         script {
        //             echo 'This is a step inside a script block'
        //             echo "${helloWorld}"
        //             sh 'touch Demo.txt'
        //             sh 'echo "Build number:${BUILD_NUMBER}" >> Demo.txt'           
        //         }
        //     }
        // }

        //     stage('Read Credentials File') {
        //             steps {
        //                 withCredentials([file(credentialsId: 'file', variable: 'CREDENTIALS_FILE')]) {
        //                     script {
        //                         def credentialsContent = readFile(file: "$CREDENTIALS_FILE")
        //                         echo "Credentials File Content: $credentialsContent"
        //                     }
        //                 }
        //             }
        //         }

        // stage('Docker Image') {
        //     agent {
        //         docker {
        //             image 'alpine:latest'
        //         }
        //     }
        //     steps {
        //         echo 'Executing Job with docker image'
        //         sh 'cat /etc/os-release'
        //     }
        // } 

        // stage('Build and push image to dockerHub') {
        //     environment {
        //         dockerHubRegistryName = "prajwalnl/aks_deploy_poc"
        //         registryURL = "https://registry.hub.docker.com"
        //         registryCredential = 'dockerhub-credential'        
        //     }
        //     steps {
        //         script {
        //             dockerHubImage = docker.build dockerHubRegistryName + ":$BUILD_NUMBER"
        //             docker.withRegistry( registryURL, registryCredential ) {   // Authenticate with Docker Hub
        //                 dockerHubImage.push()       // Push Docker image to Docker Hub
        //             }
        //             sh 'docker rmi '
        //         }
        //     }
        // }

        // stage('Build and push image to ACR') {
        //     environment {
        //         acrRegistryName = "aksdeploypoc"
        //         registryURL = "https://aksdeploypoc.azurecr.io"
        //         registryCredential = 'acr-cred'
        //     }
        //     steps {
        //         script {
        //             acrImage = docker.build acrRegistryName + ":$BUILD_NUMBER"
        //             docker.withRegistry( registryURL, registryCredential ) {   // Authenticate with ACR
        //                 acrImage.push()         // Push Docker image to ACR
        //             }
        //         }
        //     }
        // }

        // stage('Deploy to Kubernetes') {
        //     steps {
        //         sh 'kubectl apply -f aks-store-quickstart.yaml'
        //     }
        // }
    }

    post {
        always {
            //Create build artifact.
            //archiveArtifacts artifacts: 'Demo.txt'  //, fingerprint: true, excludes: 'output/*.md' 
            
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