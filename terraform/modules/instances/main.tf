# Single instance, poorly named
resource "aws_instance" "zookeeper" {
  ami = "${var.aws_ami}"
  instance_type = "${var.zookeeper_instance_type}"

  # For controlling access
  key_name = "john-oneill-IAM-keypair"

  vpc_security_group_ids = ["${var.zookeeper_vpc_security_group_ids}"]
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 100
    volume_type = "standard"
  }

  tags {
    Name = "zookeeper_instances"
  }
}
