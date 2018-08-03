output "zookeeper_sg_id" {
  description = "Zookeeper-specific security group id"
  value = "${aws_security_group.zookeeper.id}"
}
