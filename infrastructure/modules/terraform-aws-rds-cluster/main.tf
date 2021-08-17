module "rds_cluster_aurora_mysql_serverless" {
  source               = "git::https://github.com/cloudposse/terraform-aws-rds-cluster"
  namespace            = ""
  stage                = ""
  name                 = var.name
  engine               = var.engine
  engine_mode          = var.engine_mode
  engine_version       = var.engine_version
  cluster_family       = var.cluster_family
  cluster_size         = var.cluster_size
  admin_user           = var.admin_user
  admin_password       = var.admin_password
  db_name              = var.db_name
  db_port              = var.dp_port
  vpc_id               = var.vpc_id
  security_groups      = var.security_groups
  subnets              = var.subnets
  zone_id              = var.zone_id
  enable_http_endpoint = var.enable_http_endpoint
  scaling_configuration = var.scaling_configuration
}