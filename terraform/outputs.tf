output "zookeeper_elastic_ips" {
  description = "Elastic IPs of Zookeeper instance(s)"
  value = "${module.instances.zookeeper_elastic_ips}"
}

output "kafka_elastic_ips" {
  description = "Elastic IPs of Kafka broker instance(s)"
  value = "${module.instances.kafka_broker_elastic_ips}"
}

output "ssangrenel_ip" {
  description = "IP of Sangrenel instance"
  value = "${module.instances.sangrenel_ip}"
}

output "test_instance_ip" {
  description = "IP of test server"
  value = "${module.instances.test_instance_ip}"
}
