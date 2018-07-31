## Security group for Kubernetes Cluster
resource "aws_security_group" "kafka_cluster_sec_group" {
  vpc_id = "${var.vpc_id}"
  name = "${terraform.workspace}-kafka-cluster-sec-group"

  tags {
    Name = "${terraform.workspace}-kafka-sec-group"
    Environment = "${terraform.workspace}"
    Type = "public"
  }
}

# Permissions we add to the main security group:
# Ensure cluster machines can talk to one another
resource "aws_security_group_rule" "allow_all" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "-1"
  source_security_group_id = "${aws_security_group.kafka_cluster_sec_group.id}"
  security_group_id = "${aws_security_group.kafka_cluster_sec_group.id}"
}

# Open up port 22 for SSH into each machine
# The allowed locations are chosen by the user in the SSHLocation parameter
resource "aws_security_group_rule" "allow_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "-1"
  cidr_blocks     = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kafka_cluster_sec_group.id}"
}
