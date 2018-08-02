variable "vpc_security_group_ids" {
  type = "list"
  description = "A list of security group IDs to associate with"
}

variable "subnet_id" {
  description = "Subnet ID"
}
