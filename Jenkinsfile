pipeline {
    agent any

    environment {
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

        stage('Build Docker Image') {
            environment {
                DOCKER_IMAGE_NAME = "aks_deploy_poc"
            }
            steps {
                script {
                    def dockerTag = "${DOCKER_IMAGE_NAME}:${BUILD_NUMBER}"
                    dockerImage = docker.build(dockerTag)
                }
            }
        }

        stage('Tag and Push to DockerHub') {
            environment {
                REGISTRY_NAME = "prajwalnl/aks_deploy_poc"
                REGISTRY_URL = "https://registry.hub.docker.com"
                REGISTRY_CREDENTIAL = credentials('dockerhub-credential')
            }
            steps {
                script {
                    def dockerTag = "${REGISTRY_NAME}:${BUILD_NUMBER}"
                    dockerImage.tag(dockerTag)
                    docker.withRegistry(REGISTRY_URL, REGISTRY_CREDENTIAL) {
                        dockerImage.push(dockerTag)
                    }
                }
            }
        }

        // stage('Tag and Push to ACR') {
        //     environment {
        //         REGISTRY_NAME = "aksDeployPOC"
        //         REGISTRY_URL = "https://aksdeploypoc.azurecr.io"
        //         REGISTRY_CREDENTIAL = credentials('acr-cred')
        //     }
        //     steps {
        //         script {
        //             def dockerTag = "${REGISTRY_NAME}:${BUILD_NUMBER}"
        //             dockerImage.tag(dockerTag)
        //             docker.withRegistry(REGISTRY_URL, REGISTRY_CREDENTIAL) {
        //                 dockerImage.push(dockerTag)
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