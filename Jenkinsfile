pipeline {
    agent any

    stages {

        stage('Clean Workspace') {
            steps {
                deleteDir()     // Delete the entire workspace
            }
        }
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
    }

    post {
        always {
            echo 'This runs after every stage'
        }
        success {
            echo 'This runs only if the pipeline is successful'
        }
        failure {
            echo 'This runs only if the pipeline fails'
        }
    }
}
