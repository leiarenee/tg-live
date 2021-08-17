# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc

output "vpc_id" {
  value = aws_default_vpc.default.id
}

output "arn" {
  value = aws_default_vpc.default.arn
}

output "cidr_block" {
  value = aws_default_vpc.default.cidr_block
}

output "main_route_table_id" {
  value = aws_default_vpc.default.main_route_table_id
}

output "default_security_group_id" {
  value = aws_default_vpc.default.default_security_group_id
}

output "owner_id" {
  value = aws_default_vpc.default.owner_id
}

output "default_route_table_id" {
  value = aws_default_vpc.default.default_route_table_id
}


