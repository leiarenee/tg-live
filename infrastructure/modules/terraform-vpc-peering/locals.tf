locals {
  
  # Prepare map of route tables and cidrs for requester
  requester_route_tables = length(var.requester_route_tables) > 0 ? var.requester_route_tables : data.aws_route_tables.requester.ids
  acceptor_data_cidr_list = [
    for cidr in data.aws_vpc.acceptor.cidr_block_associations:
      cidr["cidr_block"]
  ]
  acceptor_cidr_block_list = length(var.acceptor_cidr_blocks) > 0 ? var.acceptor_cidr_blocks : local.acceptor_data_cidr_list

  # Make Array
  requester_rtb_cross_cidr = flatten(flatten([
    for rtb in local.requester_route_tables : [
      for cidr in local.acceptor_cidr_block_list : {    
        "rtb" : rtb
        "cidr" : cidr  
      }
    ] 
  ]))

  # Array to map
  requester_rtb_cross_cidr_map = {
    for key in local.requester_rtb_cross_cidr :  
      join("",[key["rtb"],"-",key["cidr"]]) => key
  }

  # Prepare map of route tables and cidrs for acceptor
  acceptor_route_tables = length(var.acceptor_route_tables) > 0 ? var.acceptor_route_tables : data.aws_route_tables.acceptor.ids
  requester_data_cidr_list = [
    for cidr in data.aws_vpc.requester.cidr_block_associations:
      cidr["cidr_block"]
  ]
  requester_cidr_block_list = length(var.requester_cidr_blocks) > 0 ? var.requester_cidr_blocks : local.requester_data_cidr_list

  # Make Array
  acceptor_rtb_cross_cidr = flatten(flatten([
    for rtb in local.acceptor_route_tables : [
      for cidr in local.requester_cidr_block_list : {    
        "rtb" : rtb
        "cidr" : cidr 
      }
    ] 
  ]))

  # Array to map
  acceptor_rtb_cross_cidr_map = {
    for key in local.acceptor_rtb_cross_cidr :  
      join("",[key["rtb"],"-",key["cidr"]]) => key
  }

}