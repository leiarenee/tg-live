data "aws_availability_zones" "available" {
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.78"

  name                 = var.vpc_name
  cidr                 = var.vpc.cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.vpc.enable_private_subnets ? lookup(var.vpc, "private_subnets", []) : []
  public_subnets       = var.vpc.enable_public_subnets ? lookup(var.vpc, "public_subnets", []) : []
  enable_nat_gateway   = lookup(var.vpc, "enable_nat_gateway", false)
  single_nat_gateway   = lookup(var.vpc, "single_nat_gateway", false)
  enable_dns_hostnames = lookup(var.vpc, "enable_dns_hostnames", false)
  public_subnet_tags   = var.vpc.enable_public_subnets ? lookup(var.vpc, "public_subnet_tags", {}) : {}
  private_subnet_tags  = var.vpc.enable_private_subnets ? lookup(var.vpc, "private_subnet_tags", {}) : {}
  tags                 = lookup(var.vpc, "tags", {})

}