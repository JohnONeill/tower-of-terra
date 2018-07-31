## AWS Instance
resource "aws_instance" "example_instance" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}
