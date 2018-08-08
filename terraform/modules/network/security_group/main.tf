/*

Configuration for a security group within our configured VPC sandbox,
open to all ports for any networking protocol

For more details and options on the AWS sg module, visit:
https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/1.9.0

Check out all the available sub-modules at:
https://github.com/terraform-aws-modules/terraform-aws-security-group/tree/master/modules

 */
module "open_all_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "1.9.0"

  name        = "open-to-all-sg"
  description = "Security group to make all ports publicly open...not secure at all"

  vpc_id                   = "${var.vpc_id}"
  ingress_cidr_blocks      = ["10.0.0.0/26"]
  ingress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_cidr_blocks      = ["10.0.0.0/26"]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Owner       = "john-oneill"
    Environment = "dev"
    Terraform   = "true"
  }
}
