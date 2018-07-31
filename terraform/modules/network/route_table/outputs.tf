output "public_rt_id" {
  description = "The ID of the Public Route Table"
  value       = "${aws_route_table.public_route_table.id}"
}

output "private_rt_id" {
  description = "The ID of the Private Route Table"
  value       = "${aws_route_table.private_route_table.id}"
}
