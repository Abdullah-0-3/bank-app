output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.bank-app-security-group.name
}
