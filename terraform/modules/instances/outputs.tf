output "kafka_master_public_dns_name" {
  description = "Kafka master public DNS name"
  value       = "${aws_instance.kafka_brokers_master.public_dns}"
}

output "kafka_master_private_dns_name" {
  description = "Kafka master private DNS name"
  value       = "${aws_instance.kafka_brokers_master.private_dns}"
}

output "kafka_workers_public_dns_names" {
  description = "Kafka worker(s) public DNS name(s)"
  value       = "${join(",", aws_instance.kafka_brokers_workers.*.public_dns)}"
}

output "kafka_workers_private_dns_names" {
  description = "Kafka worker(s) private DNS name(s)"
  value       = "${join(",", aws_instance.kafka_brokers_workers.*.private_dns)}"
}

output "kafka_cluster_name" {
  description = "Kafka cluster name"
  value = "${aws_instance.kafka_brokers_master.tags.Name}"
}

output "zookeeper_master_public_dns_name" {
  description = "Zookeeper master public DNS name"
  value       = "${aws_instance.zookeeper_master.public_dns}"
}

output "zookeeper_master_private_dns_name" {
  description = "Zookeeper master public DNS name"
  value       = "${aws_instance.zookeeper_master.private_dns}"
}

output "zookeeper_workers_public_dns_names" {
  description = "Zookeeper worker(s) public DNS name(s)"
  value       = "${join(",", aws_instance.zookeeper_workers.*.public_dns)}"
}

output "zookeeper_workers_private_dns_names" {
  description = "Zookeeper worker(s) private DNS name(s)"
  value       = "${join(",", aws_instance.zookeeper_workers.*.private_dns)}"
}

output "zookeeper_cluster_name" {
  description = "Zookeeper cluster name"
  value = "${aws_instance.zookeeper_master.tags.Name}"
}

output "zookeeper_cluster_id" {
  description = "Zookeeper cluster id"
  value = "${aws_instance.zookeeper_master.id}"
}
