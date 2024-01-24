pipeline {
    agent any

    stages {

        stage('Clean Workspace') {
            steps {
                sh 'ls'
                sh 'touch demo.txt'
                sh 'ls'
            }
        }
        stage('No Image') {
            steps {
                echo 'Executing Job without Image'
                sh 'cat /etc/os-release'
                sh 'ls'
                script {
                    echo 'This is a step inside a script block'
                    sh 'ls'
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
                sh 'ls'
            }
        }
    }

    post {
        always {
            echo 'This runs at end of pipeline'
            deleteDir()     // Delete the entire workspace
        }
        success {
            echo 'This runs only if the pipeline is successful'
        }
        failure {
            echo 'This runs only if the pipeline fails'
        }
    }
}
