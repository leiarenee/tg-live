variable "vpc" {
  description = "VPC Definitions"
  type        = any
  default     = {}
  # default     = {
  #   name                 = "test-vpc"
  #   cidr                 = "172.16.0.0/16",
  #   private_subnets      = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  #   public_subnets       = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]
  #   enable_nat_gateway   = false
  #   single_nat_gateway   = false
  #   enable_dns_hostnames = false
  #   public_subnet_tags = {}
  #   private_subnet_tags = {}
  # }
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = ""
}

