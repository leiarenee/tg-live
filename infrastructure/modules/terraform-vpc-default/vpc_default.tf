resource "aws_default_vpc" "default" {
  tags = {
    Name = var.default_vpc_name_tag
  }
}