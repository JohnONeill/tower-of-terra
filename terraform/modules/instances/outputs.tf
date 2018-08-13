output "zookeeper_elastic_ips" {
  description = "Elastic IPs of Zookeeper instance(s)"
  value = "${aws_eip.zookeeper_elastic_ip.*.public_ip}"
}

output "kafka_broker_elastic_ips" {
  description = "Elastic IPs of Kafka broker(s)"
  value = "${aws_eip.kafka_elastic_ip.*.public_ip}"
}

output "test_instance_ip" {
  description = "IP of test instance"
  value = "${aws_instance.test.public_ip}"
}
