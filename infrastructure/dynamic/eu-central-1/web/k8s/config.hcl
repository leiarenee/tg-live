
locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  root_tags = local.environment_vars.locals.tags
  
  
  cluster_name = "k8s-cluster"
  
  tags = merge(local.root_tags,{
    cluster_name  = local.cluster_name
  })

  
  cluster_config = {
    enabled             = true
    name                = local.cluster_name
    cluster_version     = "1.18"
    tags                = local.tags
    update_kube_config  = true
    assign_nodes_public_ip = true

    vpc = {
      name                 = "vpc-${local.cluster_name}"
      cidr                 = "172.16.0.0/16"
      private_subnets      = ["172.16.11.0/24", "172.16.12.0/24", "172.16.13.0/24"]
      enable_private_subnets = false
      public_subnets       = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
      enable_public_subnets = true
      enable_nat_gateway   = false
      single_nat_gateway   = false
      enable_dns_hostnames = true
      public_subnet_tags = {
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        "kubernetes.io/role/elb"                      = "1"
      }

      private_subnet_tags = {
        "kubernetes.io/cluster/${local.cluster_name}" = "shared"
        "kubernetes.io/role/internal-elb"             = "1"
      }

      tags = local.tags

    }

    // Additional AWS account numbers to add to the aws-auth configmap.
    // Example:
    // "321218696443",
    // "667248107216"

    map_accounts = [
      "708238176420"
    ]


    // Additional IAM roles to add to the aws-auth configmap.
    // Example:
    // {
    // rolearn  = "arn:aws:iam::592115245551:role/MyRole"
    // username = "TestRole"
    // groups   = ["system:masters"]
    // },

    map_roles = [    
      {
      rolearn  = "arn:aws:iam::684353670650:role/switch"
      username = "switch"
      groups   = ["system:masters"]
      },
    ]

    // Additional IAM users to add to the aws-auth configmap.
    // Example:
    // {
    // userarn  = "arn:aws:iam::592115245551:user/leia"
    // username = "leia"
    // groups   = ["system:masters"]
    // },

    map_users = [

    ]

    node_group = {
      defaults = {
        ami_type          = "AL2_x86_64"
        disk_size         = 10
      }
      members = {
        "t2-micro" = {
          desired_capacity = 3
          max_capacity     = 10
          min_capacity     = 1
          instance_type    = "t2.micro"
          k8s_labels = {
            Environment    = "review"
          }
          additional_tags = {
            Environment          = "review"
          }
        }
      }
    }
    use_spot_instances = true
    manage_aws_auth = false
    write_kubeconfig = true
    worker_groups_launch_template = [
    {
      # https://docs.aws.amazon.com/autoscaling/ec2/APIReference/API_InstancesDistribution.html
      # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/spot-instances.md

      name                    = "spot-1"
      override_instance_types = ["t2.small", "t3.small", "t3a.small"]
      # override_instance_types = ["t2.medium", "t3.medium","t3a.medium"]
      SpotAllocationStrategy = "lowest-price" # [lowest-price / capacity-optimized]
      spot_instance_pools     = 4
      on_demand_base_capacity = 1
      # on_demand_percentage_above_base_capacity = 25
      asg_max_size            = 10
      asg_min_size            = 0
      asg_desired_capacity    = 3
      kubelet_extra_args      = "--node-labels=node.kubernetes.io/lifecycle=`curl -s http://169.254.169.254/latest/meta-data/instance-life-cycle`"
      public_ip               = true
    }
  ]
    
    deployments = {
      metrics_server = {
        enabled = true
      }
      kubernetes_dashboard = {
        enabled = true
        csrf = "myDashboardCsrf407367"
      }
    }
  }


}

