pipeline {
    agent any

    stages {

        stage('No Image') {
            steps {
                echo 'Executing Job without Image'
                sh 'cat /etc/os-release'
                script {
                    echo 'This is a step inside a script block'
                }
            }
        }

        stage('Docker Image') {
            agent {
                docker {
                    image 'alpine:latest'
                }
            }
            steps {
                echo 'Executing Job with docker image'
                sh 'cat /etc/os-release'
            }
        }

        stage('Build and push docker image') {
            environment {
                registry = "registry.hub.docker.com/prajwalnl/test_images"
                registryCredential = 'dockerhub-credential'        
            }
            steps {
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"       // Build Docker image using Dockerfile 
                    docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {   // Authenticate with Docker Hub
                    dockerImage.push()         // Push Docker image to Docker Hub
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
