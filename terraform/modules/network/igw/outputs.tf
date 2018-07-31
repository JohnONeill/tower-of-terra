output "igw_id" {
  description = "The ID of the IGW"
  value       = "${aws_internet_gateway.internet_gateway.id}"
}
