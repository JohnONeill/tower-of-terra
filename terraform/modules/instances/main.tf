######################
# Zookeeper instances
######################

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

resource "aws_eip" "zookeeper_elastic_ip" {
  count = "${lookup(var.instance_counts, "zookeeper")}"
  instance = "${element(aws_instance.zookeeper.*.id, count.index)}"
}

resource "null_resource" "configure_zookeeper_elastic_ip" {
  count = "${lookup(var.instance_counts, "zookeeper")}"

  # Ensure that we can ssh in
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("${var.pem_file_path}")}"
    host = "${element(aws_eip.zookeeper_elastic_ip.*.public_ip, count.index)}"
  }

  # Copy configuration file over to instance
  provisioner "file" {
    source      = "${path.module}/../../remote_config_scripts/configure_and_run_zookeeper.sh"
    destination = "/tmp/configure_and_run_zookeeper.sh"
  }

  # Take configuration file and run with params
  # Use EIP count as proxy for Zookeeper instance count
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/configure_and_run_zookeeper.sh",
      "/tmp/configure_and_run_zookeeper.sh ${lookup(var.instance_counts, "zookeeper")} ${count.index} ${join(",", aws_eip.zookeeper_elastic_ip.*.public_ip)} ${var.remote_download_path}",
    ]
  }
}

##################
# Kafka instances
##################
resource "aws_instance" "kafka_broker" {
  count = "${lookup(var.instance_counts, "kafka")}"
  ami = "${lookup(var.amis, "kafka")}"
  instance_type = "${lookup(var.aws_instance_types, "kafka")}"
  key_name = "john-oneill-IAM-keypair"

  vpc_security_group_ids = ["${var.open_security_group}"]
  subnet_id = "${var.public_subnet_id}"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 100
    volume_type = "standard"
  }

  tags {
    Name        = "kafka-worker-${count.index}"
    Owner       = "john-oneill"
    Environment = "dev"
    Terraform   = "true"
    Cluster     = "kafka-brokers"
    Role        = "master"
  }
}

resource "aws_eip" "kafka_elastic_ip" {
  count = "${lookup(var.instance_counts, "kafka")}"
  instance = "${element(aws_instance.kafka_broker.*.id, count.index)}"
}

resource "null_resource" "configure_kafka_elastic_ip" {
  count = "${lookup(var.instance_counts, "kafka")}"

  # Ensure that we can ssh in
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("${var.pem_file_path}")}"
    host = "${element(aws_eip.kafka_elastic_ip.*.public_ip, count.index)}"
  }

  # Copy configuration file over to instance
  provisioner "file" {
    source      = "${path.module}/../../remote_config_scripts/configure_and_run_kafka_broker.sh"
    destination = "/tmp/configure_and_run_kafka_broker.sh"
  }

  # Take configuration file and run with params
  # Use EIP count as proxy for Kafka broker instance count
  # Use Zookeeper IDs for proper configuration
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/configure_and_run_kafka_broker.sh",
      "/tmp/configure_and_run_kafka_broker.sh ${lookup(var.instance_counts, "kafka")} ${count.index} ${join(",", aws_eip.zookeeper_elastic_ip.*.public_ip)} ${var.remote_download_path}",
    ]
  }
}

##########################
# Test instance
##########################

resource "aws_instance" "test" {
  ami = "${lookup(var.amis, "kafka")}"
  instance_type = "t2.small"
  key_name = "john-oneill-IAM-keypair"

  vpc_security_group_ids = ["${var.open_security_group}"]
  subnet_id = "${var.public_subnet_id}"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 100
    volume_type = "standard"
  }

  tags {
    Name        = "test_server"
    Owner       = "john-oneill"
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "null_resource" "test_instance_ip" {
  # Ensure that we can ssh in
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("${var.pem_file_path}")}"
    host = "${aws_instance.test.public_ip}"
  }

  # Copy configuration file over to instance
  provisioner "file" {
    source      = "${path.module}/../../remote_config_scripts/configure_and_run_kafka_broker.sh"
    destination = "/tmp/configure_and_run_kafka_broker.sh"
  }

  # Take configuration file and run with params
  # Use EIP count as proxy for Kafka broker instance count
  # Use Zookeeper IDs for proper configuration
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/configure_and_run_kafka_broker.sh",
      "/tmp/configure_and_run_kafka_broker.sh 1 0 ${join(",", aws_eip.zookeeper_elastic_ip.*.public_ip)} ${var.remote_download_path}",
    ]
  }
}
