variable "aws_ami" {
  description = "AWS ami"
}

variable "zookeeper_vpc_security_group_ids" {
  type = "list"
  description = "Security groups for Zookeeper cluster"
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
