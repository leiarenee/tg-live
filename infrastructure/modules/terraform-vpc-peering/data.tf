# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# Acceptor VPC Information
data "aws_vpc" "acceptor" {
  id    = var.acceptor_vpc_id
}

# Requester VPC Information
data "aws_vpc" "requester" {
  id    = var.requester_vpc_id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_tables
# Acceptor VPC Route tables
data "aws_route_tables" "acceptor" {
  vpc_id = var.acceptor_vpc_id
}

# Requestor VPC Route tables
data "aws_route_tables" "requester" {
  vpc_id = var.requester_vpc_id
}