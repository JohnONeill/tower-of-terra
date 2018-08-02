## AWS Instance
resource "aws_instance" "single_instance" {
  ami           = "ami-898dd9b9"
  instance_type = "t2.micro"

  # For controlling access
  key_name = "john-oneill-IAM-keypair"

  # VPC / network settings
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  # Details on device volume (either Amazon EBS or instance store volume)
  root_block_device {
    volume_size = 100
    volume_type = "standard"
  }

  # A bit silly that we have to place this in a list,
  # since it's already a list
  # https://github.com/hashicorp/terraform/pull/18062
  # https://github.com/hashicorp/terraform/issues/13869
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
}
