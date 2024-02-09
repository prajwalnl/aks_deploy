pipeline {
    agent any

    environment {
                helloWorld = "Hello World!"
                ACR_NAME = 'aksdeploypoc'
                DOCKER_IMAGE_NAME = 'aksdeploypocimage'  
            }

    stages {
        // stage('Azure resource creation') {
        //         steps {
        //             withCredentials([azureServicePrincipal('aksdeployServicePrincipal')]) {
        //                 script {
        //                     sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
        //                     sh 'az account list'
        //                     sh 'chmod a+x create_azure_setup.sh'
        //                     sh './create_azure_setup.sh'                  // Run except resource group creation.
        //                 }
        //             }
        //         }
        //     }

        // stage('Build and push image to dockerHub') {
        //     environment {
        //         dockerHubRegistryName = "prajwalnl/aks_deploy_poc"
        //         registryURL = "https://registry.hub.docker.com"
        //         registryCredential = 'dockerhub-credential'        
        //     }
        //     steps {
        //         script {
        //             dockerHubImage = docker.build dockerHubRegistryName + ":$BUILD_NUMBER"
        //             docker.withRegistry( registryURL, registryCredential ) {   // Authenticate with Docker Hub
        //                 dockerHubImage.push()       // Push Docker image to Docker Hub
        //             }
        //         }
        //     }
        // }

        // stage('Build and push image to Azure CR') {
        //         steps {
        //             script {
        //                 // Build Docker image 
        //                 sh 'docker build -t aksdeploypocimage .'
        //                 // Tag Docker image name
        //                 sh 'docker tag aksdeploypocimage aksdeploypoc.azurecr.io/aksdeploypocimage:latest'
        //                 // Push Docker image to Azure Container Registry
        //                 sh 'docker push aksdeploypoc.azurecr.io/aksdeploypocimage:latest'
        //             }
        //         }
        //     }

        // stage('Deploy to Kubernetes') {
        //     steps {
        //         sh 'kubectl apply -f aks-store-quickstart.yaml'
        //     }
        // }

        //////////////////////////////////////////////////////////////////////////////////////

        // stage('No Image and build downloadable artifact') {
        //     steps {
        //         echo 'Executing stage without docker image'
        //         sh 'echo ${helloWorld}'
        //         sh 'cat /etc/os-release'
        //         script {
        //             echo 'This is a step inside a script block'
        //             echo "${helloWorld}"
        //             sh 'touch Demo.txt'
        //             sh 'echo "Build number:${BUILD_NUMBER}" >> Demo.txt'         
        //         }
        //     }
        // }

        // stage('Use and read credentials file') {
        //     steps {
        //         withCredentials([file(credentialsId: 'file', variable: 'CREDENTIALS_FILE')]) {
        //             script {
        //                 def credentialsContent = readFile(file: "$CREDENTIALS_FILE")
        //                 echo "Credentials File Content: $credentialsContent"
        //             }
        //         }
        //     }
        // }

        // stage('Run Bash file-Multiline script') {
        //     steps {
        //         script {
        //             sh '''
        //                 chmod a+x demo_bash_script.sh
        //                 ./demo_bash_script.sh
        //             '''
        //         }   
        //     }
        // }

        // stage('Docker Image') {
        //     agent {
        //         docker {
        //             image 'alpine:latest'
        //         }
        //     }
        //     steps {
        //         echo 'Executing Job with docker image'
        //         sh 'cat /etc/os-release'
        //     }
        // }
    }

    post {
        always {
            //Create build artifact.
            //archiveArtifacts artifacts: 'Demo.txt'  //, fingerprint: true, excludes: 'output/*.md' 
            
            // Clean up Docker images, containers and workspace.
            script {
                sh 'docker rmi -f $(docker images -q)'
                sh 'docker system prune -f'
                deleteDir()
            }   
        }
        success {
            echo 'This runs only if the pipeline is successful'
        }
        failure {
            echo 'This runs only if the pipeline fails'
        }
    }
}
