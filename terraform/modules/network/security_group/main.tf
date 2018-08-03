# Kafka-specific security group
resource "aws_security_group" "kafka" {
  name        = "kafka_security_group"
  description = "Allow kafka traffic"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "kafka_security_group"
  }
}

# Zookeeper-specific security group
resource "aws_security_group" "zookeeper" {
  name        = "zookeeper_security_group"
  description = "Allow zookeeper traffic"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 31995
    to_port     = 31995
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "zookeeper_security_group"
  }
}

# Open up port 22 for SSH into each machine
# The allowed locations are chosen by the user in the SSHLocation parameter
resource "aws_security_group_rule" "allow_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.zookeeper.id}"
}
