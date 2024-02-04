pipeline {
    agent any

    environment {
                dockerHubImage = ""
                acrImage = ""   
            }

    stages {

        // stage('No Image') {
        //     steps {
        //         echo 'Executing Job without Image'
        //         sh 'cat /etc/os-release'
        //         script {
        //             echo 'This is a step inside a script block'
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
        //         sh 'cat /etc/os-release'
        //     }
        // }

        stage('Build image') {
            environment {
                dockerHubRregistryName = "prajwalnl/aks_deploy_poc"
                acrRegistryName = "aks_deploy_poc" 
            }
            steps {
                script {
                    // Build Docker image using Dockerfile
                    dockerHubImage = docker.build dockerHubRregistryName + ":$BUILD_NUMBER"
                    acrImage = docker.build acrRegistryName + ":$BUILD_NUMBER"

                }
            }
        }

        stage('Push image to dockerHub') {
            environment {
                registryURL = "https://registry.hub.docker.com"
                registryCredential = 'dockerhub-credential'        
            }
            steps {
                script {
                    docker.withRegistry( registryURL, registryCredential ) {   // Authenticate with Docker Hub
                    dockerHubImage.push()         // Push Docker image to Docker Hub
                    }
                }
            }
        }

        stage('Push image to ACR') {
            environment {
                registryURL = "https://aksdeploypoc.azurecr.io"
                registryCredential = 'acr-cred'
            }
            steps {
                script {
                    docker.withRegistry( registryURL, registryCredential ) {   // Authenticate with Docker Hub
                    acrImage.push()         // Push Docker image to Docker Hub
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