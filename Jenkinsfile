pipeline {

	agent any													//runner 

	environment {												// environment variables
		GLOBAL_VARIABLE = "global variable test: SUCCESS"
		CREDENTIALS = credentials('test-creds')
	}
	
    stages {
	
    	stage("build") {										
    		steps {
                echo "Build application"
				echo "variable: ${GLOBAL_VARIABLE}"
				echo "credentials: ${CREDENTIALS}"
			}
		}

        stage("test") {
			when {
				expression {
					BRANCH_NAME != 'main'
				}
			}
    		steps {
                echo "Test application"
				echo "variable: ${GLOBAL_VARIABLE}"
			}
		}

        stage("deploy") {
    		steps {
                echo "Deploy step"
				withCredentials([usernamePassword(credentialsId: 'test-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        echo "Username: ${USERNAME}"
                        echo "Password: ${PASSWORD}"
                    }
			}
		}		
	}

	post {
		always { echo " Pipeline Complete" }
		failure { echo " Pipeline Failed" }
		success { echo " Pipeline Success" }
	}
}