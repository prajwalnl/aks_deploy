pipeline {
    agent any

    environment {
                DOCKER_IMAGE_NAME = "test_images"
                DOCKER_IMAGE = ""   
            }

    stages {

        stage('Build Docker Image') {
            steps {
                script {
                    dockerTag = "${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                    DOCKER_IMAGE = docker.build(dockerTag) //dockerImage
                }
            }
        }

        stage('Push to DockerHub') {
            environment {
                //dockerRepoName = "prajwalnl/"
                registryURL = "https://registry.hub.docker.com"
                registryCredential = 'dockerhub-credential' 
            }
            steps {
                script {
                    def dockerTag = "registry.hub.docker.com/prajwalnl/${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                    docker.withRegistry(registryURL, registryCredential) {
                        DOCKER_IMAGE.push(dockerTag)
                    }
                }
            }
        }

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