resource "aws_instance" "zookeeper" {
  count = 3
  ami = "${lookup(var.amis, "zookeeper")}"
  instance_type = "${lookup(var.aws_instance_types, "zookeeper")}"
  key_name = "john-oneill-IAM-keypair"

  vpc_security_group_ids = ["${var.open_security_group}"]
  subnet_id = "${var.public_subnet_id}"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 100
    volume_type = "standard"
  }

  tags {
    Name        = "zookeeper-worker-${count.index}"
    Owner       = "john-oneill"
    Environment = "dev"
    Terraform   = "true"
    Cluster     = "zookeepers"
    Role        = "master"
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("${var.pem_file_path}")}"
  }

  # Copy zookeeper setup script to remote and execute
  provisioner "remote-exec" {
    script = "${path.module}/../../../packer/remote_config_scripts/configure_and_run_zookeeper.sh"
  }
}
