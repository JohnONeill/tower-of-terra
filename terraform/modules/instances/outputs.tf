output "zookeeper_public_dns_names" {
  description = "Public DNS name(s) of Zookeeper instance(s)"
  value = "${aws_instance.zookeeper.*.public_dns}"
}
