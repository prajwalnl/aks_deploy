pipeline {
    agent any

    stages {

        stage('Clean Workspace') {
            steps {
                sh 'ls'
                //sh 'touch demo.txt'
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
            echo 'This runs at end of pipeline'
            //deleteDir()     // Delete the entire workspace
        }
        success {
            echo 'This runs only if the pipeline is successful'
        }
        failure {
            echo 'This runs only if the pipeline fails'
        }
    }
}
