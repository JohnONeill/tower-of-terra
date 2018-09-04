output "open_security_group_id" {
  description = "Open all security group id"
  value = "${aws_security_group.open_all_sg.id}"
}
