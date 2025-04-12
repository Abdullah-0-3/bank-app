output "public_ip" {
  description = "The public IP address of the instance"
  value       = module.instance.public_ip
}

output "public_dns" {
  description = "The public DNS address of the instance"
  value       = module.instance.public_dns
}