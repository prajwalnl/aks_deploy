pipeline {
    agent any

    environment{
        
        registry = "prajwalnl/test_images"
        registryCredential = 'dockerhub-credential'        
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
        
        // stage('Alpine Image') {
        //     agent {
        //         docker {
        //             image 'alpine:latest'
        //         }
        //     }
        //     steps {
        //         echo 'Executing Job with Alpine Image'
        //         sh 'cat /etc/os-release'
        //     }
        // }

        stage('Build and push docker image') {
            steps{
                script {
                    ls
                    cat Dockerfile
                    sh 'docker images'
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"      // Build Docker image using Dockerfile 
                    sh 'docker images'
                    docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {   // Authenticate with Docker Hub
                    dockerImage.push()              // Push Docker image to Docker Hub
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
