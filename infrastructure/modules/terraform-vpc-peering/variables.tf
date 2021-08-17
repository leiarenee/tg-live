variable "name" {
  type        = string
  default     = "VPC Peering"
  description = "Name tag for Vpc peering connection"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags"
}

variable "requester_vpc_id" {
  type        = string
  description = "VPC Id to connect with default VPC through peering."
}

variable "acceptor_vpc_id" {
  type        = string
  description = "VPC Id to connect with default VPC through peering."
}

variable "acceptor_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of acceptor CIDR Blocks to create route in requester route tables. Automatically fetched if not assigned."
}

variable "requester_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of requester CIDR Blocks to create route in acceptor route tables. Automatically fetched if not assigned."
}

variable "acceptor_route_tables" {
  type        = list(string)
  default     = []
  description = "List of acceptor route table ids to create routes for requester CIDR Blocks. Automatically fetched if not assigned."
}

variable "requester_route_tables" {
  type        = list(string)
  default     = []
  description = "List of requester route table ids to create routes for acceptor CIDR Blocks. Automatically fetched if not assigned."
}

variable "acceptor_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "When enabled local dns names are resolved within the vpc."
}

variable "requester_allow_remote_vpc_dns_resolution" {
  type        = bool
  default     = true
  description = "When enabled local dns names are resolved within the vpc."
}

variable "auto_accept" {
  type        = bool
  default     = true
  description = "Automatically accept the peering (both VPCs need to be in the same AWS account)"
}

variable "create_timeout" {
  type        = string
  description = "VPC peering connection create timeout. For more details, https://www.terraform.io/docs/configuration/blocks/resources/syntax.html"
  default     = "3m"
}

variable "update_timeout" {
  type        = string
  description = "VPC peering connection update timeout. For more details, see https://www.terraform.io/docs/configuration/blocks/resources/syntax.html"
  default     = "3m"
}

variable "delete_timeout" {
  type        = string
  description = "VPC peering connection delete timeout. For more details, https://www.terraform.io/docs/configuration/blocks/resources/syntax.html"
  default     = "5m"
}