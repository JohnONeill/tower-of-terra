# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.vpc_cidr_prefix}.${var.subnet_cider_block_suffixes["public"]}"
  availability_zone = "${var.aws_region}a"

  tags {
    Name = "${terraform.workspace}-public-subnet"
    Environment = "${terraform.workspace}"
    Type = "public"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.vpc_cidr_prefix}.${var.subnet_cider_block_suffixes["private"]}"
  availability_zone = "${var.aws_region}a"

  tags {
    Name = "${terraform.workspace}-private-subnet"
    Environment = "${terraform.workspace}"
    Type = "private"
  }
}

## Route table associations
resource "aws_route_table_association" "public_subnet" {
  subnet_id = "${aws_subnet.public_subnet.id}"
  route_table_id = "${var.public_rt_id}"
}

resource "aws_route_table_association" "private_subnet" {
  subnet_id = "${aws_subnet.private_subnet.id}"
  route_table_id = "${var.private_rt_id}"
}
