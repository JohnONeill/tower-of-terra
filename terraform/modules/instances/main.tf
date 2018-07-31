## AWS Instance
resource "aws_instance" "single_instance" {
  ami           = "ami-898dd9b9"
  instance_type = "t2.micro"
}
