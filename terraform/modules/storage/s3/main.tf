## IGW
resource "aws_s3_bucket" "data_source_bucket" {
  bucket = "insight-jo-data-source-bucket"
  acl = "private"
  tags {
    Name        = "Data source bucket"
    Environment = "prod"
  }
}
