pipeline {
    agent any

    environment {
                DOCKER_IMAGE_NAME = "test-image"    
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

        stage('Build Docker Image') {
            steps {
                script {
                    dockerTag = "${DOCKER_IMAGE_NAME}:${BUILD_NUMBER_TAG}"
                    dockerImage = docker.build(dockerTag)
                }
            }
        }

        stage('Push to DockerHub') {
            environment {
                //registryName = "prajwalnl/test_images"
                registryURL = "https://registry.hub.docker.com"
                registryCredential = 'dockerhub-credential' 
            }
            steps {
                script {
                    def dockerTag = "${DOCKER_IMAGE_NAME}:${BUILD_NUMBER_TAG}"
                    docker.withRegistry(registryURL, registryCredential) {
                        dockerImage.push(dockerTag)
                    }
                }
            }
        }

        // stage('Push image to DockerHub') {
        //     environment {
        //         registryName = "prajwalnl/test_images"
        //         registryURL = "https://registry.hub.docker.com"
        //         registryCredential = 'dockerhub-credential'        
        //     }
        //     steps {
        //         script {
        //             docker.withRegistry( registryURL, registryCredential ) {   // Authenticate with Docker Hub
        //             dockerImage.push()         // Push Docker image to Docker Hub
        //             }
        //         }
        //     }
        // }





        // stage('Push to ACR') {
        //     steps {
        //         script {
        //             def dockerTag = "${ACR_USERNAME}/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER_TAG}"
        //             docker.withRegistry('https://aksdeploypoc.azurecr.io', ACR_USERNAME, ACR_PASSWORD) {
        //                 dockerImage.push(dockerTag)
        //             }
        //         }
        //     }
        // }

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