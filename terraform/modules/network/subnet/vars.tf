variable "aws_region" {
  description = "AWS Region"
}

## VPC Variables
variable "vpc_id" {
  description = "ID of the VPC to create subnet"
}

variable "vpc_cidr_prefix" {
  description = "First 2 sections of the VPC CIDR block "
}

## Route Table
variable "public_rt_id" {
  description = "ID of the Public Route Table"
}
variable "private_rt_id" {
  description = "ID of the Private Route Table"
}

variable "subnet_cider_block_suffixes" {
  type = "map"
  default = {
    # 10.0.128.0 -> 10.0.225.255
    "private" = "128.0/17"
    # 10.0.0.0 -> 10.0.127.255
    "public" = "0.0/17"
  }
}
