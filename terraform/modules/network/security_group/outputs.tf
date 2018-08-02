output "cluster_sg_id" {
  description = "The ID of the Security Group Id"
  value       = "${aws_security_group.kafka_cluster_sec_group.id}"
}
