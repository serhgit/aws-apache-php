pipeline {
    agent any
    stages {
        stage ('Docker Image Build') {
            steps {
                script {
                    app = docker.build("apache-php-web", "-f Dockerfile .")
                }
            }
        }
    }
}
