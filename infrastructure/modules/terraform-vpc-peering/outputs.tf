output "peer_vpc_id" {
  value = aws_vpc_peering_connection.default_to_k8s.id
}

output "requester_routes" {
  value = local.requester_rtb_cross_cidr_map
}

output "acceptor_routes" {
  value = local.acceptor_rtb_cross_cidr_map
}