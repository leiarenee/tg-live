# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection
# Resource for VPC Peering Connection
resource "aws_vpc_peering_connection" "default_to_k8s" {
  peer_vpc_id   = var.acceptor_vpc_id
  vpc_id        = var.requester_vpc_id
  auto_accept   = var.auto_accept
  
  accepter {
    allow_remote_vpc_dns_resolution = var.acceptor_allow_remote_vpc_dns_resolution
  }
  
  requester {
    allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution
  }
  
  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }

  tags = merge(var.tags,{
    Name = var.name
  })
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
# Create Requestor Routes
resource "aws_route" "requester" {
  for_each = local.requester_rtb_cross_cidr_map
  route_table_id            = each.value["rtb"]
  destination_cidr_block    = each.value["cidr"]
  vpc_peering_connection_id = aws_vpc_peering_connection.default_to_k8s.id
  depends_on = [data.aws_route_tables.requester, data.aws_vpc.acceptor, aws_vpc_peering_connection.default_to_k8s]
}

# Create Acceptor Routes
resource "aws_route" "acceptor" {
  for_each = local.acceptor_rtb_cross_cidr_map
  route_table_id            = each.value["rtb"]
  destination_cidr_block    = each.value["cidr"]
  vpc_peering_connection_id = aws_vpc_peering_connection.default_to_k8s.id
  depends_on = [data.aws_route_tables.acceptor, data.aws_vpc.requester, aws_vpc_peering_connection.default_to_k8s]
}