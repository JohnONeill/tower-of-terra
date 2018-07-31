# S3 bucket id
output "s3_bucket_id" {
  description = "Bucket id"
  value       = "${aws_s3_bucket.data_source_bucket.id}"
}

# S3 bucket domain name
output "s3_bucket_domain_name" {
  description = "Bucket domain name"
  value       = "${aws_s3_bucket.data_source_bucket.bucket_domain_name}"
}
