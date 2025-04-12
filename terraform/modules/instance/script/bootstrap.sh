#!/bin/bash

# Set up logging
LOG_FILE="/var/log/bootstrap.log"
exec > >(tee -a ${LOG_FILE}) 2>&1

echo "===== Bank App Bootstrap Script Started at $(date) ====="

# Function to install Docker
install_docker() {
    echo "Installing Docker..."
    apt-get update -y
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ubuntu
    echo "Docker installed successfully."
}

# Function to install Jenkins
install_jenkins() {
    echo "Installing Jenkins..."
    apt-get update -y
    apt-get install -y openjdk-11-jdk
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
    sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    apt-get update -y
    apt-get install -y jenkins
    systemctl enable jenkins
    systemctl start jenkins
    JENKINS_PORT=$(grep "JENKINS_PORT" /etc/default/jenkins | cut -d'=' -f2)
    echo "Jenkins installed successfully on port $JENKINS_PORT."
    echo "Initial admin password: $(cat /var/lib/jenkins/secrets/initialAdminPassword)"
}

# Function to install kubectl
install_kubectl() {
    echo "Installing kubectl..."
    KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/
    echo "kubectl version ${KUBECTL_VERSION} installed successfully."
}

# Function to create welcome file
create_welcome_file() {
    echo "Creating welcome file..."
    PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
    JENKINS_PORT=$(grep "JENKINS_PORT" /etc/default/jenkins | cut -d'=' -f2 || echo "8080")
    
    cat > /home/ubuntu/welcome.txt << 'EOF'
*************************************************************
*         WELCOME TO THE BANK APP DEPLOYMENT SERVER         *
*************************************************************

This server has been provisioned with the following tools:
  - Docker: Container runtime for application deployment
  - Jenkins: CI/CD automation server 
  - Kubectl: Kubernetes command-line tool

JENKINS ACCESS:
  URL: http://${PUBLIC_IP}:${JENKINS_PORT}
  Initial Admin Password: See /var/lib/jenkins/secrets/initialAdminPassword

DOCKER INFORMATION:
  Run docker commands with 'sudo docker' or as the ubuntu user
  after reconnecting to the SSH session.

GENERAL INFORMATION:
  - Server bootstrap script log: ${LOG_FILE}
  - Server was provisioned on: $(date)

For assistance, please contact the DevOps team.
*************************************************************
EOF
    
    # Fix the variables in the welcome file
    sed -i "s|\${PUBLIC_IP}|$PUBLIC_IP|g" /home/ubuntu/welcome.txt
    sed -i "s|\${JENKINS_PORT}|$JENKINS_PORT|g" /home/ubuntu/welcome.txt
    sed -i "s|\${LOG_FILE}|$LOG_FILE|g" /home/ubuntu/welcome.txt
    
    chown ubuntu:ubuntu /home/ubuntu/welcome.txt
    echo "Welcome file created at /home/ubuntu/welcome.txt"
}

# Main execution
echo "Starting installation process..."
install_docker
install_jenkins
install_kubectl
create_welcome_file

# Finishing up
echo "===== Bootstrap Script Completed at $(date) ====="
echo "Jenkins URL: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080"
echo "Please check /home/ubuntu/welcome.txt for more information."