output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = "${aws_subnet.public_subnet.id}"
}

output "public_subnet_cidr_block" {
  description = "The CIDR block of public subnet"
  value       = "${aws_subnet.public_subnet.cidr_block}"
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = "${aws_subnet.private_subnet.id}"
}

output "private_subnet_cidr_block" {
  description = "The CIDR block of private subnet"
  value       = "${aws_subnet.private_subnet.cidr_block}"
}
