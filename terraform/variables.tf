locals {
  # Global Vars
  region      = "us-west-2"
  environment = "dev"
  name        = "bank-app"

  tags = {
    Name        = "${local.name}-${local.environment}"
    Environment = local.environment
    Terraform   = "true"
  }

  # Security Group Vars
  security_group_name = "${local.name}-${local.environment}-sg"

  # Instance Vars
  instance_type = "t2.micro"
  key_name      = "bank-app-key"

}