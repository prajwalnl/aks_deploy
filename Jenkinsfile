pipeline {
    agent any

    environment {
                imageName = "test_image:${BUILD_NUMBER}"
                dockerImage = ""      
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
            steps {
                script {
                    dockerImage = docker.build imageName    // Build Docker image using Dockerfile 
                }
            }
        }

        stage('Push image to DockerHub') {
            environment {
                registryName = "prajwalnl/aks_deploy_poc"
                registryURL = "https://registry.hub.docker.com"
                registryCredential = 'dockerhub-credential'       //credentials('dockerhub-credential') 
            }
            steps {
                script {
                    sh ('docker tag ${imageName} ${registryName}:${BUILD_NUMBER}')
                    testImage2 = docker.image('${registryName}:${BUILD_NUMBER}')
                    sh ('echo $testImage2')
                    docker.withRegistry( registryURL, registryCredential ) {   // Authenticate with Docker Hub
                    testImage2.push()         // Push Docker image to Docker Hub
                    }
                }
            }
        }

        // stage('Push image to ACR') {
        //     environment {
        //         registryName = "aksdeploypoc"
        //         registryURL = "https://aksdeploypoc.azurecr.io"
        //         registryCredential = 'acr-cred'
        //     }
        //     steps {
        //         script {
        //             docker.withRegistry( registryURL, registryCredential ) {   // Authenticate with Docker Hub
        //             dockerImage.push()         // Push Docker image to Docker Hub
        //             }
        //         }
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