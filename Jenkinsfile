pipeline {
    agent any

    stages {

        stage('No Image') {
            steps {
                echo 'Executing Job without Image'
                sh 'echo "Hello, Jenkins!"'
                sh 'ls'
                sh 'cat /etc/os-release'
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

    }
}
