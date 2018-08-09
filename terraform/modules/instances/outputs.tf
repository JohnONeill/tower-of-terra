output "elastic_ips_zookeeper" {
  description = "Elastic IPs of Zookeeper instance(s)"
  value = "${aws_eip.elastic_ip.*.public_ip}"
}
