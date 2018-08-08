### Brokers

output "kafka_master_public_dns_name" {
  description = "Kafka master public DNS name"
  value = "${module.instances.kafka_master_public_dns_name}"
}

output "kafka_master_private_dns_name" {
  description = "Kafka master private DNS name"
  value       = "${module.instances.kafka_master_private_dns_name}"
}

output "kafka_workers_public_dns_name" {
  description = "Kafka worker(s) DNS name(s)"
  value = "${module.instances.kafka_workers_public_dns_names}"
}

output "kafka_workers_private_dns_names" {
  description = "Kafka worker(s) private DNS name(s)"
  value       = "${module.instances.kafka_workers_private_dns_names}"
}

output "kafka_cluster_name" {
  description = "Kafka cluster name"
  value = "${module.instances.kafka_cluster_name}"
}

### Zookeeper

output "zookeeper_master_public_dns_name" {
  description = "Zookeeper master(s) public DNS name(s)"
  value = "${module.instances.zookeeper_master_public_dns_name}"
}

output "zookeeper_master_private_dns_name" {
  description = "Zookeeper master private DNS name"
  value       = "${module.instances.zookeeper_master_private_dns_name}"
}

output "zookeeper_workers_public_dns_name" {
  description = "Zookeeper worker(s) public DNS name(s)"
  value = "${module.instances.zookeeper_workers_public_dns_names}"
}

output "zookeeper_workers_private_dns_names" {
  description = "Zookeeper worker(s) private DNS name(s)"
  value       = "${module.instances.zookeeper_workers_private_dns_names}"
}

output "zookeeper_cluster_name" {
  description = "Kafka cluster name"
  value = "${module.instances.zookeeper_cluster_name}"
}
