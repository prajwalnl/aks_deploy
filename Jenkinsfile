pipeline {
    agent {
        docker {
            image 'alpine:latest'
        }
    }

    stages {
        stage('Print OS Name') {
            steps {
                sh 'uname -a'
            }
        }
    }
}
