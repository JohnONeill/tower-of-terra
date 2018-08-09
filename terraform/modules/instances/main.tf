resource "aws_instance" "zookeeper" {
  count = "${lookup(var.instance_counts, "zookeeper")}"
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
}

#
# @TODO: move to own module
#
resource "aws_eip" "elastic_ip" {
  count = "${lookup(var.instance_counts, "zookeeper")}"
  instance = "${element(aws_instance.zookeeper.*.id, count.index)}"

  # Ensure that we can ssh in
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("${var.pem_file_path}")}"
    host = "${self.public_ip}"
  }

  # Copy configuration file over to instance
  provisioner "file" {
    source      = "${path.module}/../../../packer/remote_config_scripts/configure_and_run_zookeeper.sh"
    destination = "/tmp/configure_and_run_zookeeper.sh"
  }

  # Create utils/shell folder
  # provisioner "remote-exec" {
  #   inline = [
  #     "mkdir /tmp/utils",
  #   ]
  # }

  # Copy over shell utils
  # provisioner "file" {
  #   source      = "${path.module}/../../../utils/shell"
  #   destination = "/tmp/utils"
  # }

  # Take configuration file and run with params
  # Use EIP count as proxy for Zookeeper instance count
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/configure_and_run_zookeeper.sh",
      "/tmp/configure_and_run_zookeeper.sh ${var.remote_download_path} ${count.index} ${self.public_ip}",
    ]
  }
}
