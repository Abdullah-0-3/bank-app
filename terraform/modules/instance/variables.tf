variable "tags" {
  description = "values for the tags"
  type        = map(string)
}

variable "key_name" {
  description = "values for the key pair name"
  type        = string
}

variable "instance_type" {
  description = "values for the instance type"
  type        = string
}

variable "security_group_name" {
  description = "Name of the security group to attach to the instance"
  type        = string
}