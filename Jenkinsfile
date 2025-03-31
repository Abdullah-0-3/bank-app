pipeline {
    agent any

    environment {
        SONAR_HOME = tool 'sonarQubeScanner'
    }

    stages {
        stage("Cleaning Workspace") {
            steps {
                cleanWs()
            }
        }

        stage("Cloning Repository") {
            steps {
                git url: 'https://github.com/Abdullah-0-3/bank-app', branch: 'master'
            }
        }

        stage("SonarQube Analysis") {
            steps {
                withSonarQubeEnv(credentialsId: 'sonarQubeToken', installationName: 'sonarQubeScanner') {
                    sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=bankApplication -Dsonar.projectKey=bank -X"
                }
            }
        }
    }

}