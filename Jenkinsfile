pipeline {
    agent any
    stages {
        stage ('Verify AWS ECR repository exists') {
		steps {
			withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: "AWS IAM Admin",
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
				script {
					env.REPO_TAG = sh ( script: '''
						AWS_CLI="/usr/local/bin/aws --region=\"us-east-1\""
						REPO_TAG=`${AWS_CLI} ecr describe-repositories --repository-names ${AWS_ECR_REPO_NAME} | jq .repositories[0].repositoryUri | sed -e \"s/^\\\"//g\" -e \"s/\\\"$//g\"`
						echo -n ${REPO_TAG}
					''',returnStdout: true).trim()
				}
			}
		}
	}
        stage ('Docker Image Build') {
            steps {
                script {
			withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: "AWS IAM Admin",
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
				
                    		app = docker.build("${env.REPO_TAG}", "-f Dockerfile .")
			}
                }
            }
        }
	stage ('Push image') {
		steps {
			script {
			withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: "AWS IAM Admin",
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
				sh '''
					AWS_CLI="/usr/local/bin/aws --region=\"us-east-1\""
					AWS_ECR_PASS=$(${AWS_CLI} ecr get-login-password)
					docker login --username AWS -p ${AWS_ECR_PASS} ${REPO_TAG} 
				'''
				app.push("${env.ENVIRONMENT}-latest")
				app.push("${env.ENVIRONMENT}-${env.BUILD_NUMBER}")
			}
			}
		}
	}
    }
}
