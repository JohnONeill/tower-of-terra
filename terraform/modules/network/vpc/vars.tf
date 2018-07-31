## VPC setup
variable "vpc_cidr_prefix" {
  type = "map"

  default = {
    "dev" = "10.1"
    "staging" = "10.2"
    "prod" = "10.10"
  }
}

variable "vpc_cidr_suffix" {
  type = "map"

  default = {
    "dev" = "0.0/16"
    "staging" = "0.0/16"
    "prod" = "0.0/16"
  }
}
