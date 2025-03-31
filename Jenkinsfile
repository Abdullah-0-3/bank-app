pipeline {
    agent any

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
    }

}