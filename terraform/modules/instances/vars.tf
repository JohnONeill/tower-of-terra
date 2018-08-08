variable "aws_ami" {
  description = "AWS ami"
}

variable "subnet_id" {
  description = "Subnet ID"
}

variable "kafka_cluster_size" {
  default = "3"
}

variable "zookeeper_cluster_size" {
  default = "3"
}

variable "zookeeper_instance_type" {
  default = "t2.small"
}

variable "kafka_instance_type" {
  default = "t2.small"
}

variable "open_security_group" {
  default = "Open security group"
}
