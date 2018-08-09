output "elastic_ips_zookeeper" {
  description = "Elastic IPs of Zookeeper instance(s)"
  value = "${module.instances.elastic_ips_zookeeper}"
}
