pipeline {
    agent any

    environment {
                helloWorld = "Hello World!"   
            }

    stages {

        stage('No Image') {
            steps {
                echo 'Executing Job without Image'
                sh 'echo ${helloWorld}'
                sh 'helm'
                sh 'kubectl'
                sh 'az version'
                sh 'az account show'
                sh 'az account list'
                sh 'kubectl config get-contexts'
                sh 'kubectl get deployments --all-namespaces=true'
                script {
                    echo 'This is a step inside a script block'
                    echo "${helloWorld}"
                }
            }
        }

    //     stage('No Image') {
    //         steps {
    //             echo 'Executing Job without Image'
    //             sh 'echo ${helloWorld}'
    //             sh 'cat /etc/os-release'
    //             script {
    //                 echo 'This is a step inside a script block'
    //                 echo "${helloWorld}"
    //             }
    //         }
    //     }

    //     stage('Docker Image') {
    //         agent {
    //             docker {
    //                 image 'alpine:latest'
    //             }
    //         }
    //         steps {
    //             echo 'Executing Job with docker image'
    //             sh 'cat /etc/os-release'
    //         }
    //     } 

    //     stage('Build and push image to dockerHub') {
    //         environment {
    //             dockerHubRegistryName = "prajwalnl/aks_deploy_poc"
    //             registryURL = "https://registry.hub.docker.com"
    //             registryCredential = 'dockerhub-credential'        
    //         }
    //         steps {
    //             script {
    //                 dockerHubImage = docker.build dockerHubRegistryName + ":$BUILD_NUMBER"
    //                 docker.withRegistry( registryURL, registryCredential ) {   // Authenticate with Docker Hub
    //                     dockerHubImage.push()       // Push Docker image to Docker Hub
    //                 }
    //             }
    //         }
    //     }

    //     stage('Build and push image to ACR') {
    //         environment {
    //             acrRegistryName = "aks_deploy_poc" 
    //             registryURL = "https://aksdeploypoc.azurecr.io"
    //             registryCredential = 'acr-cred'
    //         }
    //         steps {
    //             script {
    //                 acrImage = docker.build acrRegistryName + ":$BUILD_NUMBER"
    //                 docker.withRegistry( registryURL, registryCredential ) {   // Authenticate with ACR
    //                     acrImage.push()         // Push Docker image to ACR
    //                 }
    //             }
    //         }
    //     }
    // }

    // post {
    //     always {
    //         // Clean up Docker images, containers and workspace.
    //         script {
    //             sh 'docker rmi -f $(docker images -q)'
    //             sh 'docker system prune -f'
    //             deleteDir()
    //         }   
    //     }
    //     success {
    //         echo 'This runs only if the pipeline is successful'
    //     }
    //     failure {
    //         echo 'This runs only if the pipeline fails'
    //     }
    }
}