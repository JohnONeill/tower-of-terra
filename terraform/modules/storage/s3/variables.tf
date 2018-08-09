## VPC Variables
variable "vpc_id" {
  description = "ID of the VPC to create subnet"
}

variable "bucket_name" {
  default = "insight-jo-data-source-bucket"
  description = "Name for S3 bucket"
}
