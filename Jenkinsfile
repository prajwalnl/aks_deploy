pipeline {
    agent any

    environment {
                helloWorld = "Hello World!"   
            }

    stages {

        // stage('No Image') {
        //     steps {
        //         echo 'Executing Job without Image'
        //         sh 'echo ${helloWorld}'
        //         sh 'cat /etc/os-release'
        //         script {
        //             echo 'This is a step inside a script block'
        //             echo ${helloWorld}
        //         }
        //     }
        // }

        // stage('Docker Image') {
        //     agent {
        //         docker {
        //             image 'alpine:latest'
        //         }
        //     }
        //     steps {
        //         echo 'Executing Job with docker image'
        //         echo ${helloWorld}
        //         sh 'cat /etc/os-release'
        //     }
        // } 

        stage('Build and push image to dockerHub') {
            environment {
                dockerHubRegistryName = "prajwalnl/aks_deploy_poc"
                registryURL = "https://registry.hub.docker.com"
                registryCredential = credentials('dockerhub-credential') //'dockerhub-credential'        
            }
            steps {
                script {
                    dockerHubImage = docker.build dockerHubRegistryName + ":$BUILD_NUMBER"
                    docker.withRegistry( registryURL, registryCredential ) {   // Authenticate with Docker Hub
                        // Push Docker image to Docker Hub with latest and build tag
                        dockerHubImage.push()
                        //dockerHubImage.push(latest)         
                    }
                }
            }
        }

        stage('Build and push image to ACR') {
            environment {
                acrRegistryName = "aks_deploy_poc" 
                registryURL = "https://aksdeploypoc.azurecr.io"
                registryCredential = credentials('acr-cred')   //'acr-cred'
            }
            steps {
                script {
                    acrImage = docker.build acrRegistryName + ":$BUILD_NUMBER"
                    docker.withRegistry( registryURL, registryCredential ) {   // Authenticate with ACR
                        acrImage.push()         // Push Docker image to ACR
                    }
                }
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