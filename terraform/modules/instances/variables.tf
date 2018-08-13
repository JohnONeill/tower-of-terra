variable "amis" {
  type = "map"
  description = "Machine image files"
}

variable "aws_instance_types" {
  type = "map"
  description = "AWS instance types"
}

variable "instance_counts" {
  type = "map"
  default = {
    zookeeper = 3,
    kafka = 3
  }
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

variable "remote_download_path" {
  description = "Path on remote server to download any files (e.g., for configuration)"
}
