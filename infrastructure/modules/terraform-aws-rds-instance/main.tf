# Uncomment if default vpc is used
data "aws_vpc" "default" {
  count = var.use_default_vpc ? 1 : 0
  default = true
}

data "aws_subnet_ids" "all" {
  count = var.use_default_vpc ? 1 : 0
  vpc_id = data.aws_vpc.default.0.id
}

data "aws_security_group" "default" {
  count = var.use_default_vpc ? 1 : 0
  vpc_id = data.aws_vpc.default.0.id
  name   = "default"
}

module "rds_instance" {
    source = "git::https://github.com/cloudposse/terraform-aws-rds"
    namespace                   = var.namespace
    stage                       = var.stage
    name                        = var.name
    dns_zone_id                 = var.dns_zone_id
    host_name                   = var.host_name
    ca_cert_identifier          = var.ca_cert_identifier
    database_name               = var.database_name
    database_user               = var.database_user
    database_password           = var.database_password
    database_port               = var.database_port
    multi_az                    = var.multi_az
    storage_type                = var.storage_type
    allocated_storage           = var.allocated_storage
    storage_encrypted           = var.storage_encrypted
    engine                      = var.engine
    engine_version              = var.engine_version
    major_engine_version        = var.major_engine_version
    instance_class              = var.instance_class
    db_parameter_group          = var.db_parameter_group
    option_group_name           = var.option_group_name
    publicly_accessible         = var.publicly_accessible
    snapshot_identifier         = var.snapshot_identifier
    auto_minor_version_upgrade  = var.auto_minor_version_upgrade
    allow_major_version_upgrade = var.allow_major_version_upgrade
    apply_immediately           = var.apply_immediately
    maintenance_window          = var.maintenance_window
    skip_final_snapshot         = var.skip_final_snapshot
    copy_tags_to_snapshot       = var.copy_tags_to_snapshot
    backup_retention_period     = var.backup_retention_period
    backup_window               = var.backup_window
    db_parameter                = var.db_parameter
    db_options                  = var.db_options

    # Default vpc is not used
    security_group_ids          = var.use_default_vpc ? [data.aws_security_group.default.0.id] : var.security_group_ids
    allowed_cidr_blocks         = var.use_default_vpc ? [data.aws_vpc.default.0.cidr_block] : var.allowed_cidr_blocks
    subnet_ids                  = var.use_default_vpc ? data.aws_subnet_ids.all.0.ids : var.subnet_ids
    vpc_id                      = var.use_default_vpc ? data.aws_vpc.default.0.id : var.vpc_id

    # Internally Calculated Parameters if default vpc is used
    // security_group_ids          = [data.aws_security_group.default.id]
    // allowed_cidr_blocks         = [data.aws_vpc.default.cidr_block]
    // subnet_ids                  = data.aws_subnet_ids.all.ids
    // vpc_id                      = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "ingress_all" {
  description       = "Allow inbound traffic from all"
  type              = "ingress"
  from_port         = var.database_port
  to_port           = var.database_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.rds_instance.security_group_id
}