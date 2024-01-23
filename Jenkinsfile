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
                sh 'uname -a'
            }
        }
    }
}
