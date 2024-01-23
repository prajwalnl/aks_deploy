pipeline {
    agent any

    stages {

        stage('No Image') {
            steps {
                echo 'Executing Job without Image'
                sh 'echo "Hello, Jenkins!"'
                sh 'ls'
                sh 'uname -a'
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
                sh 'uname -a'
            }
        }

    }
}
