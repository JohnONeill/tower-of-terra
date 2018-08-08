resource "aws_instance" "zookeeper_master" {
  count = 1
  ami = "${var.aws_ami}"
  instance_type = "${var.zookeeper_instance_type}"
  key_name = "john-oneill-IAM-keypair"

  vpc_security_group_ids = ["${var.open_security_group}"]
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 100
    volume_type = "standard"
  }

  tags {
    Name = "zookeeper_instance"
  }

  tags {
    Name        = "zookeepers"
    Owner       = "john-oneill"
    Environment = "dev"
    Terraform   = "true"
    Cluster     = "zookeepers"
    ClusterRole = "master"
    Role        = "master"
  }
}

resource "aws_instance" "zookeeper_workers" {
  count = 1
  ami = "${var.aws_ami}"
  instance_type = "${var.zookeeper_instance_type}"
  key_name = "john-oneill-IAM-keypair"

  vpc_security_group_ids = ["${var.open_security_group}"]
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 100
    volume_type = "standard"
  }

  tags {
    Name = "zookeeper_instance"
  }

  tags {
    Name        = "zookeepers" # name of cluster, enables access to `peg fetch x`
    SelfName    = "zookeeper-worker-${count.index}"
    Owner       = "john-oneill"
    Environment = "dev"
    Terraform   = "true"
    Role        = "worker"
  }
}

resource "aws_instance" "kafka_brokers_master" {
  count = 1
  ami = "${var.aws_ami}"
  instance_type   = "${var.kafka_instance_type}"
  key_name = "john-oneill-IAM-keypair"

  vpc_security_group_ids = ["${var.open_security_group}"]
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = true

  root_block_device {
    volume_size = 100
    volume_type = "standard"
  }

  tags {
    Name        = "kafka-master-${count.index}"
    Owner       = "john-oneill"
    Environment = "dev"
    Terraform   = "true"
    Cluster     = "kafka_brokers"
    ClusterRole = "master"
  }
}

resource "aws_instance" "kafka_brokers_workers" {
  count = 1
  ami = "${var.aws_ami}"
  instance_type = "${var.kafka_instance_type}"
  key_name = "john-oneill-IAM-keypair"

  vpc_security_group_ids = ["${var.open_security_group}"]
  subnet_id                   = "${var.subnet_id}"
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
    Cluster     = "kafka_brokers"
    ClusterRole = "worker"
  }
}
