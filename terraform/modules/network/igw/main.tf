## Internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${terraform.workspace}-internet-gateway"
    Environment = "${terraform.workspace}"
  }
}
