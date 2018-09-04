variable "amis" {
  type = "map"
  description = "Machine image files"
  default = {
    zookeeper = "ami-0a2cb2967c8730af1",
    kafka = "ami-0361b3924eb51d6ba",
    sangrenel = "ami-097cf91ff67813094"
  }
}

variable "aws_instance_types" {
  type = "map"
  description = "AWS instance types"
  default = {
    zookeeper = "t2.small",
    kafka = "t2.medium",
    sangrenel = "t2.medium"
  }
}

variable "instance_counts" {
  description = "Count of each instance type"
  type = "map"
  default = {
    zookeeper = 3,
    kafka = 3,
    sangrenel = 0
  }
}

variable "open_security_group" {
  description = "Open all security group id"
}

variable "pem_file_path" {
  description = "Path of pem file"
}

variable "public_key_path" {
  description = "Path of public key"
}

variable "public_subnet_id" {
  description = "The ID of the public subnet"
}

variable "remote_download_path" {
  description = "Path on remote server to download any files (e.g., for configuration)"
}

variable "enable_kafka_detailed_monitor" {
  description = "Enable detailed monitoring of Kafka server (only applies to first broker)"
  default = "false"
}

variable "sangrenel_flag_auto_launch_test" {
  description = "Boolean to begin stress test as soon as instance is created"
  default = "on"
}

variable "sangrenel_flag_message_size" {
  description = "Message size (bytes) (default 300)"
  default = "800"
}

variable "sangrenel_flag_batch_size" {
  description = "Messages per batch (default 500)"
  default = "500"
}

variable "sangrenel_flag_num_workers" {
  description = "Number of workers (default 1)"
  default = "10"
}
