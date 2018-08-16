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
    kafka = 3,
    sangrenel = 1
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
