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
        
        stage('Alpine Image') {
            agent {
                docker {
                    image 'alpine:latest'
                }
            }
            steps {
                echo 'Executing Job with Alpine Image'
                sh 'cat /etc/os-release'
            }
        }

        stage('Build and push docker image') {
            steps {
                script {
                    // Build Docker image using Dockerfile
                    dockerImage = docker.build("prajwalnl/test_images:${BUILD_NUMBER}", "-f Dockerfile .")

                    // Authenticate with Docker Hub
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub_credentials') {
                    
                    // Push Docker image to Docker Hub
                    dockerImage.push()
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker images and containers
            script {
                sh 'docker rmi -f $(docker images -q)'
                sh 'docker system prune -f'
            }
            deleteDir()
        }
        success {
            echo 'This runs only if the pipeline is successful'
        }
        failure {
            echo 'This runs only if the pipeline fails'
        }
    }
}
