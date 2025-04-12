# Bank Application Infrastructure

This repository contains Terraform configuration for deploying the infrastructure required for the Bank Application.

## Overview

This Terraform project provisions the following AWS resources:
- EC2 instance for hosting the bank application
- Security groups for controlling network access
- Key pairs for secure SSH access

## Directory Structure

```
terraform/
├── main.tf                  # Main Terraform configuration
├── variables.tf             # Variable definitions and local values
├── outputs.tf               # Output values
├── provider.tf              # Provider configuration
├── modules/                 # Reusable modules
│   ├── instance/            # EC2 instance module
│   │   ├── main.tf          # Instance resource definition
│   │   ├── variables.tf     # Module variables
│   │   ├── outputs.tf       # Module outputs
│   │   ├── keys/            # SSH key pairs
│   │   └── script/          # Bootstrap scripts
│   │       └── bootstrap.sh # Instance initialization script
│   └── security_group/      # Security group module
│       ├── main.tf          # Security group resource definition
│       ├── variables.tf     # Module variables
│       └── outputs.tf       # Module outputs
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (>= 1.0.0)
- AWS account with appropriate permissions
- AWS CLI configured with access credentials

## Usage

1. Initialize the Terraform working directory:
   ```
   terraform init
   ```

2. Review the execution plan:
   ```
   terraform plan
   ```

3. Apply the changes:
   ```
   terraform apply
   ```

4. To destroy the infrastructure:
   ```
   terraform destroy
   ```

## Infrastructure Components

### EC2 Instance

The EC2 instance is provisioned with:
- Ubuntu 22.04 LTS (Jammy Jellyfish)
- Docker for containerization
- Jenkins for CI/CD pipelines
- Kubectl for Kubernetes management

The bootstrap script (`bootstrap.sh`) automatically installs these components during instance initialization.

### Security Groups

The security group allows:
- SSH access (port 22)
- HTTP access (port 80)
- Jenkins access (port 8080)

## Configuration

The infrastructure can be customized through variables in `variables.tf`:

| Variable | Description | Default |
|----------|-------------|---------|
| region | AWS region | us-west-2 |
| environment | Environment (dev, staging, prod) | dev |
| instance_type | EC2 instance type | t2.micro |

## Outputs

After provisioning, the following outputs are provided:
- `public_ip`: Public IP address of the EC2 instance
- `public_dns`: Public DNS name of the EC2 instance

## Access

To access the instance:
```
ssh -i modules/instance/keys/bank-app.pvt ubuntu@<public_ip>
```

To access Jenkins:
```
http://<public_ip>:8080
```

## Creating Your Own SSH Keys

For security reasons, you should create your own SSH key pair rather than using the provided sample keys:

1. Generate a new ED25519 key pair:
   ```
   ssh-keygen -t ed25519 -f bank-app -C "your_email@example.com"
   ```

2. Copy the keys to the appropriate location:
   ```
   cp bank-app modules/instance/keys/bank-app.pvt
   cp bank-app.pub modules/instance/keys/bank-app.pub
   ```

3. Set appropriate permissions:
   ```
   chmod 600 modules/instance/keys/bank-app.pvt
   ```
