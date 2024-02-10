pipeline {
    agent any

    environment {
                helloWorld = "Hello World!"
                ACR_NAME = 'testacr'
                DOCKER_IMAGE_NAME = 'testimage'  
            }

    stages {
        stage('Multi script stage') {
            steps {
                input 'Do you approve deployment?'
                script {
                    //Run Bash file
                    //Multiline script
                    //create downloadable artifact "Demo.txt"
                    sh '''
                        chmod a+x demo_bash_script.sh
                        ./demo_bash_script.sh
                    '''
                }   
            }
        }
        // stage('Azure resource creation') {
        //         steps {
        //             input 'Do you approve deployment?' 
        //             withCredentials([azureServicePrincipal('aksdeployServicePrincipal')]) {
        //                 script {
        //                     sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
        //                     sh 'az account list'
        //                     //sh 'chmod a+x create_azure_setup.sh'
        //                     //sh './create_azure_setup.sh'                  // Run except resource group creation.
        //                 }
        //             }
        //         }
        //     }

        // stage('Build and push image to Azure CR') {
        //         steps {
        //             script {
        //                 // Build Docker image 
        //                 sh 'docker build -t testimage .'
        //                 // Tag Docker image name
        //                 sh 'docker tag testimage aksdeploypoc.azurecr.io/testimage:latest'
        //                 // Push Docker image to Azure Container Registry
        //                 sh 'docker push testacr.azurecr.io/testimage:latest'
        //             }
        //         }
        //     }

        // stage('Deploy to Kubernetes') {
        //     steps {
        //         sh 'kubectl apply -f aks-store-quickstart.yaml'
        //     }
        // }
    }

    post {
        always {            
            // Clean up Docker images, containers and workspace.
            script {
                //sh 'docker rmi -f $(docker images -q)'
                //sh 'docker system prune -f'
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
