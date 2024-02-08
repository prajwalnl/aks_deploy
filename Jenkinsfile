pipeline {
    agent any

    environment {
                helloWorld = "Hello World!"   
            }

    stages {
        stage('Azure Login and List Accounts') {
                steps {
                    withCredentials([azureServicePrincipal('aksdeployServicePrincipal')]) {
                        script {
                            sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                            sh 'az account list'
                        }
                    }
                }
            }

        // stage('Azure Login and List Accounts ---- detailed') {
        //     steps {
        //         withCredentials([azureServicePrincipal(credentialsId: 'your-credentials-id', tenantId: 'your-tenant-id', clientId: 'your-client-id', clientSecret: 'your-client-secret')]) {
        //             script {
        //                 sh 'az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET --tenant $TENANT_ID'
        //                 sh 'az account list'
        //                 //sh 'kubectl apply -f your-kubernetes-config.yaml'
        //             }
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