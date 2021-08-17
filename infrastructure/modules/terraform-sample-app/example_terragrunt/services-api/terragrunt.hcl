locals {
  # Get deploy inputs
  deploy_inputs = jsondecode(file("deploy.inputs.tfvars.json"))
  
}

terraform {
  #source = "git::git@bitbucket.org:bettermarks-devops/terraform-sub-modules.git//terraform-sample-app"
  source = "${get_parent_terragrunt_dir()}/terraform-sub-modules/terraform-sample-app"

  extra_arguments "tf_arguments" {
  commands = ["apply","plan","destroy","apply-all","plan-all","destroy-all"]
  required_var_files = [
    "${get_terragrunt_dir()}/deploy.inputs.tfvars.json"
    ]
  }
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

inputs = {
  module_enabled = true

  raw_config = {
    deployment = {
      metadata = {
        labels = {
            antiAffinity = "review"
        }
      },
      spec = {
        strategy = {
          type = "Recreate"
        }
      },
      "spec.template.metadata.labels" = {
        antiAffinity = "review"
      },
      "spec.template.spec" = {
        nodeSelector = {
          "beta.kubernetes.io/instance-type" = "t2.micro"
        },
        affinity = {
          podAntiAffinity = {
            requiredDuringSchedulingIgnoredDuringExecution = {
              labelSelector = {
                matchExpressions = [{
                  key = "antiAffinity"
                  operator = "In"
                  values = ["review"]
                }],
                topologyKey: "kubernetes.io/hostname"
              }
            }
            
          }
        }
      },
      "spec.template.spec.containers" = [
        {
          ports = [
            {containerPort = 80}
          ],

          env = concat(local.deploy_inputs.env,
          [
            {   name = "_"     ,value = "_" },

          ]),

          # resources = {
          #   requests = {
          #     cpu: "200m"
          #     memory: "200M"
          #   },
          #   limits = {
          #     cpu: "200m"
          #     memory: "200M"
          #   }
          # }

        }

      ]
    },
    service = {
      spec = {
        session_affinity = "ClientIP",
        ports = [
          {
            port = 80,
            targetPort = 80
          }
        ],
        type = "LoadBalancer"
      }
    }
  }
}


dependencies {
  paths = ["../redis-mongo-postgres", "../create-k8s-namespace"]
}
