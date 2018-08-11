output "elastic_ips_zookeeper" {
  description = "Elastic IPs of Zookeeper instance(s)"
  value = "${aws_eip.elastic_ip.*.public_ip}"
}

output "test_instance_ip" {
  description = "IP of test instance"
  value = "${aws_instance.test.public_ip}"
}
