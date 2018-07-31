output "instance_id" {
  description = "The ID of our EC2 instance"
  value       = "${aws_instance.single_instance.id}"
}
