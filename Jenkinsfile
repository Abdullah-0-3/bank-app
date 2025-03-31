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
        stage("Installing Dependency") {
            steps {
                sh "mvn clean install -DskipTests=True"
            }
        }
        stage("SonarQube Analysis") {
            steps {
                withSonarQubeEnv(credentialsId: 'sonarQubeToken', installationName: 'sonarQubeScanner') {
                    sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=bankApplication -Dsonar.projectKey=bank -Dsonar.java.binaries=target/classes -X"
                }
            }
        }
        stage("SonarQube Quality Gates") {
            steps {
                timeout(time: 2, unit: "MINUTES") {
                    waitForQualityGate abortPipeline: false
                }
            }
        }
        stage("Docker Build") {
            steps {
                sh "docker build -t bank-app ."
            }
        }
        stage("Image Scanning") {
            steps {
                sh "trivy image --format table bank-app > trivy-scan.txt"
            }
        }
        stage("Docker Push") {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerHubCredentials',
                        passwordVariable: 'dockerPassword',
                        usernameVariable: 'dockerUsername'
                    )    
                ]) {
                    sh "docker tag bank-app $dockerUsername/devops:bank-app"
                    sh "echo $dockerPassword | docker login --username $dockerUsername --password-stdin"
                    sh "docker push $dockerUsername/devops:bank-app"
                    sh "docker logout"
                }
            }
        }
    }
    
    post {
        always {
            script {
                def status = currentBuild.result ?: 'SUCCESS' 
                def color = (status == 'SUCCESS') ? '#28a745' : '#dc3545'
                def icon = (status == 'SUCCESS') ? '✅' : '❌'
                def buttonColor = (status == 'SUCCESS') ? '#28a745' : '#dc3545'
                def subjectStatus = (status == 'SUCCESS') ? 'SUCCESS' : 'FAILURE'
                def projectName = env.JOB_BASE_NAME 
                def attachmentsPattern = 'trivy-scan.txt'
    
                // Build the email body
                def emailBody = """
                <!DOCTYPE html>
                <html>
                <head>
                    <style>
                        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
                        .container { max-width: 600px; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); }
                        .header { background: ${color}; color: white; padding: 15px; font-size: 18px; font-weight: bold; text-align: center; border-radius: 5px 5px 0 0; }
                        .content { padding: 20px; color: #333; line-height: 1.6; }
                        .footer { text-align: center; font-size: 12px; color: #777; margin-top: 20px; }
                        .button { display: inline-block; padding: 10px 20px; margin-top: 20px; background: ${buttonColor}; color: white; text-decoration: none; border-radius: 5px; font-weight: bold; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <div class="header">${icon} Jenkins Pipeline Execution - ${subjectStatus}</div>
                        <div class="content">
                            <p><strong>Project Name:</strong> ${projectName}</p>
                            <p>The Jenkins pipeline for <strong>${projectName}</strong> has ${status == 'SUCCESS' ? 'been successfully executed.' : 'encountered a failure. Please review the logs and investigate the issue.'}</p>
                            <p>You can check the build details by clicking the button below:</p>
                            <a href="${env.BUILD_URL}" class="button">View Pipeline</a>
                        </div>
                        <div class="footer">Automated Notification | Jenkins</div>
                    </div>
                </body>
                </html>
                """
    
                // Send the email
                emailext(
                    subject: "${icon} ${subjectStatus} - Jenkins Pipeline: ${projectName}",
                    body: emailBody,
                    mimeType: 'text/html',
                    to: 'abdullahabrar4843@gmail.com', // Replace with your actual recipient email(s)
                    attachmentsPattern: attachmentsPattern
                )
            }
        }
    }

}