

output "vpc_config" {
  value = merge(var.vpc,{
    id = module.vpc.vpc_id
    azs = module.vpc.azs 
    private_subnet_ids = module.vpc.private_subnets
    public_subnet_ids = module.vpc.public_subnets
    ssh_security_id = aws_security_group.allow_ssh.id
    private_route_table_ids = module.vpc.private_route_table_ids
    public_route_table_ids = module.vpc.public_route_table_ids
    vpc_main_route_table_id = module.vpc.vpc_main_route_table_id
    default_security_group_id = module.vpc.default_security_group_id
    })
}


