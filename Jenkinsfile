pipeline {
    agent any/*{
        docker {
            image 'alpine:latest'
        }
    }*/

    stages {
        stage('Print OS Name') {
            steps {
                echo "Test docker container"
                script {
                    sh 'ls'
                    sh 'cat Dockerfile'
                    sh 'uname -a'
                }  
            }
        }
    }
}
