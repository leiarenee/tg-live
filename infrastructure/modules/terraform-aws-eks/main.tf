
resource "aws_key_pair" "sshkey" {
  key_name   = "${var.cluster.name}-sshkey"
  public_key = var.ssh_public_key
}

locals {
  cluster_config = merge(
    var.cluster,
    { 
    worker_groups_launch_template = [
      merge(var.cluster.worker_groups_launch_template[0],{
      key_name = aws_key_pair.sshkey.key_name
      additional_security_group_ids = [var.vpc_config.ssh_security_id]
      })
    ]
    
    node_group = merge(var.cluster.node_group,{
      members = {
        for member, config in var.cluster.node_group.members:
          member => merge(config,{
            key_name = aws_key_pair.sshkey.key_name
            #source_security_group_ids = [var.vpc_config.ssh_security_id]
          })
      }
    })
  })

  
  
}

module "eks" {
  #source                = "./terraform-aws-eks"
  source  = "terraform-aws-modules/eks/aws"
  version = "15.1.0"
  create_eks            = local.cluster_config.enabled
  #cluster_name          = local.cluster_config.name
  cluster_version       = local.cluster_config.cluster_version
  vpc_id                = var.vpc_config.id
  subnets               = local.cluster_config.assign_nodes_public_ip ? var.vpc_config.public_subnet_ids : var.vpc_config.private_subnet_ids
  tags                = merge(local.cluster_config.tags,
    {
      "k8s.io/cluster-autoscaler/enabled" = "owned"
      "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    })
  node_groups_defaults  = local.cluster_config.use_spot_instances ? null : local.cluster_config.node_group.defaults
  node_groups           = local.cluster_config.use_spot_instances ? {} : local.cluster_config.node_group.members
  map_roles             = local.cluster_config.map_roles
  map_users             = local.cluster_config.map_users
  map_accounts          = local.cluster_config.map_accounts
  worker_groups_launch_template = local.cluster_config.use_spot_instances ? local.cluster_config.worker_groups_launch_template : []
  manage_aws_auth       = local.cluster_config.manage_aws_auth
  
  cluster_enabled_log_types                     = var.cluster_enabled_log_types
  cluster_log_kms_key_id                        = var.cluster_log_kms_key_id
  cluster_log_retention_in_days                 = var.cluster_log_retention_in_days
  cluster_name                                  = var.cluster_name
  cluster_security_group_id                     = var.cluster_security_group_id
  config_output_path                            = var.config_output_path
  write_kubeconfig                              = var.write_kubeconfig
  aws_auth_additional_labels                    = var.aws_auth_additional_labels
  worker_groups                                 = var.worker_groups
  workers_group_defaults                        = var.workers_group_defaults
  worker_security_group_id                      = var.worker_security_group_id
  worker_ami_name_filter                        = var.worker_ami_name_filter
  worker_ami_name_filter_windows                = var.worker_ami_name_filter_windows
  worker_ami_owner_id                           = var.worker_ami_owner_id
  worker_ami_owner_id_windows                   = var.worker_ami_owner_id_windows
  worker_additional_security_group_ids          = var.worker_additional_security_group_ids
  worker_sg_ingress_from_port                   = var.worker_sg_ingress_from_port
  workers_additional_policies                   = var.workers_additional_policies
  kubeconfig_aws_authenticator_command          = var.kubeconfig_aws_authenticator_command   
  kubeconfig_aws_authenticator_command_args     = var.kubeconfig_aws_authenticator_command_args     
  kubeconfig_aws_authenticator_additional_args  = var.kubeconfig_aws_authenticator_additional_args
  kubeconfig_aws_authenticator_env_variables    = var.kubeconfig_aws_authenticator_env_variables
  kubeconfig_name                               = var.kubeconfig_name
  cluster_create_timeout                        = var.cluster_create_timeout
  cluster_delete_timeout                        = var.cluster_delete_timeout
  wait_for_cluster_cmd                          = var.wait_for_cluster_cmd
  wait_for_cluster_interpreter                  = var.wait_for_cluster_interpreter
  cluster_create_security_group                 = var.cluster_create_security_group
  worker_create_security_group                  = var.worker_create_security_group
  worker_create_initial_lifecycle_hooks               = var.worker_create_initial_lifecycle_hooks
  worker_create_cluster_primary_security_group_rules  = var.worker_create_cluster_primary_security_group_rules
  permissions_boundary                                = var.permissions_boundary
  iam_path                                            = var.iam_path
  cluster_create_endpoint_private_access_sg_rule      = var.cluster_create_endpoint_private_access_sg_rule
  cluster_endpoint_private_access_cidrs         = var.cluster_endpoint_private_access_cidrs
  cluster_endpoint_private_access               = var.cluster_endpoint_private_access
  cluster_endpoint_public_access                = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs          = var.cluster_endpoint_public_access_cidrs
  manage_cluster_iam_resources                  = var.manage_cluster_iam_resources
  cluster_iam_role_name                         = var.cluster_iam_role_name
  manage_worker_iam_resources                   = var.manage_worker_iam_resources
  workers_role_name                             = var.workers_role_name
  attach_worker_cni_policy                      = var.attach_worker_cni_policy
  enable_irsa                                   = var.enable_irsa
  eks_oidc_root_ca_thumbprint                   = var.eks_oidc_root_ca_thumbprint
  cluster_encryption_config                     = var.cluster_encryption_config
  fargate_profiles                              = var.fargate_profiles
  create_fargate_pod_execution_role             = var.create_fargate_pod_execution_role
  fargate_pod_execution_role_name               = var.fargate_pod_execution_role_name
  
}

// resource "null_resource" "update_kube_config" {
//   count = local.cluster_config.enabled && local.cluster_config.update_kube_config ? 1 : 0
//   depends_on = [module.eks]

//   provisioner "local-exec" {
//     command = "aws eks update-kubeconfig --profile ${var.aws_profile} --name ${local.cluster_config.name}"
//   }
// }

locals {
# Workgroup Parameters- This is for help - not used in program 
  workers_group_defaults_defaults = {
    name                          = "count.index"               # Name of the worker group. Literal count.index will never be used but if name is not set, the count.index interpolation will be used.
    tags                          = []                          # A list of map defining extra tags to be applied to the worker group autoscaling group.
    ami_id                        = ""                          # AMI ID for the eks linux based workers. If none is provided, Terraform will search for the latest version of their EKS optimized worker AMI based on platform.
    ami_id_windows                = ""                          # AMI ID for the eks windows based workers. If none is provided, Terraform will search for the latest version of their EKS optimized worker AMI based on platform.
    asg_desired_capacity          = "1"                         # Desired worker capacity in the autoscaling group and changing its value will not affect the autoscaling group's desired capacity because the cluster-autoscaler manages up and down scaling of the nodes. Cluster-autoscaler add nodes when pods are in pending state and remove the nodes when they are not required by modifying the desirec_capacity of the autoscaling group. Although an issue exists in which if the value of the asg_min_size is changed it modifies the value of asg_desired_capacity.
    asg_max_size                  = "3"                         # Maximum worker capacity in the autoscaling group.
    asg_min_size                  = "1"                         # Minimum worker capacity in the autoscaling group. NOTE: Change in this paramater will affect the asg_desired_capacity, like changing its value to 2 will change asg_desired_capacity value to 2 but bringing back it to 1 will not affect the asg_desired_capacity.
    asg_force_delete              = false                       # Enable forced deletion for the autoscaling group.
    asg_initial_lifecycle_hooks   = []                          # Initital lifecycle hook for the autoscaling group.
    asg_recreate_on_change        = false                       # Recreate the autoscaling group when the Launch Template or Launch Configuration change.
    default_cooldown              = null                        # The amount of time, in seconds, after a scaling activity completes before another scaling activity can start.
    health_check_grace_period     = null                        # Time in seconds after instance comes into service before checking health.
    instance_type                 = "m4.large"                  # Size of the workers instances.
    spot_price                    = ""                          # Cost of spot instance.
    placement_tenancy             = ""                          # The tenancy of the instance. Valid values are "default" or "dedicated".
    root_volume_size              = "100"                       # root volume size of workers instances.
    root_volume_type              = "gp2"                       # root volume type of workers instances, can be 'standard', 'gp2', or 'io1'
    root_iops                     = "0"                         # The amount of provisioned IOPS. This must be set with a volume_type of "io1".
    key_name                      = ""                          # The key name that should be used for the instances in the autoscaling group
    pre_userdata                  = ""                          # userdata to pre-append to the default userdata.
    userdata_template_file        = ""                          # alternate template to use for userdata
    userdata_template_extra_args  = {}                          # Additional arguments to use when expanding the userdata template file
    bootstrap_extra_args          = ""                          # Extra arguments passed to the bootstrap.sh script from the EKS AMI (Amazon Machine Image).
    additional_userdata           = ""                          # userdata to append to the default userdata.
    ebs_optimized                 = true                        # sets whether to use ebs optimization on supported types.
    enable_monitoring             = true                        # Enables/disables detailed monitoring.
    public_ip                     = false                       # Associate a public ip address with a worker
    kubelet_extra_args            = ""                          # This string is passed directly to kubelet if set. Useful for adding labels or taints.
    #subnets                       = var.subnets                 # A list of subnets to place the worker nodes in. i.e. ["subnet-123", "subnet-456", "subnet-789"]
    additional_security_group_ids = []                          # A list of additional security group ids to include in worker launch config
    protect_from_scale_in         = false                       # Prevent AWS from scaling in, so that cluster-autoscaler is solely responsible.
    iam_instance_profile_name     = ""                          # A custom IAM instance profile name. Used when manage_worker_iam_resources is set to false. Incompatible with iam_role_id.
    iam_role_id                   = "local.default_iam_role_id" # A custom IAM role id. Incompatible with iam_instance_profile_name.  Literal local.default_iam_role_id will never be used but if iam_role_id is not set, the local.default_iam_role_id interpolation will be used.
    suspended_processes           = ["AZRebalance"]             # A list of processes to suspend. i.e. ["AZRebalance", "HealthCheck", "ReplaceUnhealthy"]
    target_group_arns             = null                        # A list of Application LoadBalancer (ALB) target group ARNs to be associated to the autoscaling group
    enabled_metrics               = []                          # A list of metrics to be collected i.e. ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity"]
    placement_group               = null                        # The name of the placement group into which to launch the instances, if any.
    service_linked_role_arn       = ""                          # Arn of custom service linked role that Auto Scaling group will use. Useful when you have encrypted EBS
    termination_policies          = []                          # A list of policies to decide how the instances in the auto scale group should be terminated.
    platform                      = "linux"                     # Platform of workers. either "linux" or "windows"
    additional_ebs_volumes        = []                          # A list of additional volumes to be attached to the instances on this Auto Scaling group. Each volume should be an object with the following: block_device_name (required), volume_size, volume_type, iops, encrypted, kms_key_id (only on launch-template), delete_on_termination. Optional values are grabbed from root volume or from defaults
    # Settings for launch templates
    #root_block_device_name            = data.aws_ami.eks_worker.root_device_name # Root device name for workers. If non is provided, will assume default AMI was used.
    root_kms_key_id                   = ""                                       # The KMS key to use when encrypting the root storage device
    launch_template_version           = "$Latest"                                # The lastest version of the launch template to use in the autoscaling group
    launch_template_placement_tenancy = "default"                                # The placement tenancy for instances
    launch_template_placement_group   = null                                     # The name of the placement group into which to launch the instances, if any.
    root_encrypted                    = false                                    # Whether the volume should be encrypted or not
    eni_delete                        = true                                     # Delete the Elastic Network Interface (ENI) on termination (if set to false you will have to manually delete before destroying)
    cpu_credits                       = "standard"                               # T2/T3 unlimited mode, can be 'standard' or 'unlimited'. Used 'standard' mode as default to avoid paying higher costs
    market_type                       = null
    # Settings for launch templates with mixed instances policy
    override_instance_types                  = ["m5.large", "m5a.large", "m5d.large", "m5ad.large"] # A list of override instance types for mixed instances policy
    on_demand_allocation_strategy            = null                                                 # Strategy to use when launching on-demand instances. Valid values: prioritized.
    on_demand_base_capacity                  = "0"                                                  # Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances
    on_demand_percentage_above_base_capacity = "0"                                                  # Percentage split between on-demand and Spot instances above the base on-demand capacity
    spot_allocation_strategy                 = "lowest-price"                                       # Valid options are 'lowest-price' and 'capacity-optimized'. If 'lowest-price', the Auto Scaling group launches instances using the Spot pools with the lowest price, and evenly allocates your instances across the number of Spot pools. If 'capacity-optimized', the Auto Scaling group launches instances using Spot pools that are optimally chosen based on the available Spot capacity.
    spot_instance_pools                      = 10                                                   # "Number of Spot pools per availability zone to allocate capacity. EC2 Auto Scaling selects the cheapest Spot pools and evenly allocates Spot capacity across the number of Spot pools that you specify."
    spot_max_price                           = ""                                                   # Maximum price per unit hour that the user is willing to pay for the Spot instances. Default is the on-demand price
    max_instance_lifetime                    = 0                                                    # Maximum number of seconds instances can run in the ASG. 0 is unlimited.
  }
}