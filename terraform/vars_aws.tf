# AWS Region
variable "aws_region" {
  description = "AWS region to launch servers."
  default = "us-west-2"
}

variable "aws_ami" {
  default = "ami-898dd9b9"
}