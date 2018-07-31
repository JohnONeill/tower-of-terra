## Public routetable
resource "aws_route_table" "public_route_table" {
  vpc_id = "${var.vpc_id}"

  # Default route through Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.igw_id}"
  }

  tags {
    Name = "${terraform.workspace}-public-route-table"
    Environment = "${terraform.workspace}"
    Type = "public"
  }
}

## Private routetable
resource "aws_route_table" "private_route_table" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${terraform.workspace}-private-route-table"
    Environment = "${terraform.workspace}"
    Type = "public"
  }
}
