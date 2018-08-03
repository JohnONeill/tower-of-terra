output "zookeeper_cluster_id" {
  description = "Zookeeper cluster id"
  value       = "${aws_instance.zookeeper.*.id}"
}

output "zookeeper_cluster_public_dns_names" {
  description = "Zookeeper cluster id"
  value       = "${aws_instance.zookeeper.*.public_dns}"
}
