pipeline {
    agent none
    stages {
        stage('Back-end') {
            agent {
                any { image 'maven:3.9.6-eclipse-temurin-17-alpine' }
            }
            steps {
                sh 'mvn --version'
            }
        }
        stage('Front-end') {
            agent {
                any { image 'node:20.11.0-alpine3.19' }
            }
            steps {
                sh 'node --version'
            }
        }
    }
}