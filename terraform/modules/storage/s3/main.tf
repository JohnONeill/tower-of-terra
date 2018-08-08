## IGW
resource "aws_s3_bucket" "data_source_bucket" {
  bucket = "${var.bucket_name}"
  acl = "private"

  tags {
    Name        = "Data source bucket"
    Environment = "prod"
  }
}
