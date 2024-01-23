pipeline {
    agent any/*{
        docker {
            image 'alpine:latest'
        }
    }*/

    stages {
        stage('Print OS Name') {
            steps {
                script {
                    sh 'echo "Hello World"'
                    echo 'This is another step'
                }
                echo 'This is a step outside the script block'
            }
        }
    }
}
