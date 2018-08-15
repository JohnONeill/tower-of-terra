## VPC setup
variable "vpc_cidr_prefix" {
  type = "map"

  default = {
    "default" = "10.1"
    "staging" = "10.2"
    "prod" = "10.10"
  }
}

variable "vpc_cidr_suffix" {
  type = "map"

  default = {
    "default" = "0.0/16"
    "staging" = "0.0/16"
    "prod" = "0.0/16"
  }
}
