pipeline {
    agent {
        docker {
            image 'alpine:latest'
        }
    }
    
    stages {
        stage('Example') {
            steps {
                echo 'Running on Alpine'
                sh 'ls'
                sh 'uname -a'
            }
        }
    }
}
