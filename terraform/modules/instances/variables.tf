variable "amis" {
  type = "map"
  description = "Machine image files"
}

variable "aws_instance_types" {
  type = "map"
  description = "AWS instance types"
}

variable "open_security_group" {
  description = "Open all security group id"
}

variable "pem_file_path" {
  description = "Path of pem file"
}

variable "public_subnet_id" {
  description = "The ID of the public subnet"
}
