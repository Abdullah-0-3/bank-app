variable "security_group_name" {
  description = "Name of the security group"
  type        = string
}

variable "tags" {
  description = "values for the tags"
  type        = map(string)
}