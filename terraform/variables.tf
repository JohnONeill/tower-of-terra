# AWS Region
variable "aws_region" {
  description = "AWS region to launch servers"
  default = "us-west-2"
}

variable "amis" {
  description = "Machine image files"
  type = "map"
  default = {
    zookeeper = "ami-07ba83c3895c0e952"
  }
}

variable "aws_instance_types" {
  description = "AWS instance types"
  type = "map"
  default = {
    zookeeper = "t2.micro"
  }
}

##########################
# Set by terraform.tfvars
##########################

variable "remote_download_path" {
  description = "Path on remote server to download any files (e.g., for configuration)"
}

variable "pem_file_path" {
  description = "Path of pem file"
}
