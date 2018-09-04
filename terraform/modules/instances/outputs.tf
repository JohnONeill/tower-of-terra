output "zookeeper_elastic_ips" {
  description = "Elastic IPs of Zookeeper instance(s)"
  value = "${aws_eip.zookeeper_elastic_ip.*.public_ip}"
}

output "kafka_broker_elastic_ips" {
  description = "Elastic IPs of Kafka broker(s)"
  value = "${aws_eip.kafka_elastic_ip.*.public_ip}"
}

output "sample_kafka_broker_instance_id" {
  description = "Instance ID of sample kafka broker"
  value = "${aws_instance.kafka_broker.0.id}"
}

output "sangrenel_ips" {
  description = "IP of Sangrenel instance(s)"
  value = "${aws_instance.sangrenel.*.public_ip}"
}
