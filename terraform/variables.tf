################
# AWS specifics
################
variable "aws_region" {
  description = "AWS region to launch servers"
  default = "us-west-2"
}

variable "amis" {
  description = "Machine image files"
  type = "map"
  default = {
    zookeeper = "ami-0a2cb2967c8730af1",
    kafka = "ami-0361b3924eb51d6ba",
    sangrenel = "ami-097cf91ff67813094"
  }
}

variable "aws_instance_types" {
  description = "AWS instance types"
  type = "map"
  default = {
    zookeeper = "t2.small",
    kafka = "t2.medium",
    sangrenel = "t2.medium"
  }
}

#####################
# Sangrenel settings
#####################

variable "sangrenel_flag_auto_launch_test" {
  description = "Boolean to begin stress test as soon as instance is created"
  default = "off"
}

variable "sangrenel_flag_message_size" {
  description = "Value for sangrenel's -message-size flag"
  default = "800"
}

variable "sangrenel_flag_batch_size" {
  description = "Value for sangrenel's -message-batch-size flag"
  default = "500"
}

variable "sangrenel_flag_num_workers" {
  description = "Value for sangrenel's -workers flag"
  default = "10"
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

variable "public_key_path" {
  default = ""
}
