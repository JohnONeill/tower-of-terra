output "elastic_ips_zookeeper" {
  description = "Elastic IPs of Zookeeper instance(s)"
  value = "${module.instances.elastic_ips_zookeeper}"
}

output "test_instance_ip" {
  description = "IP of test server"
  value = "${module.instances.test_instance_ip}"
}
