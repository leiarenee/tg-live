

# runs the "merge_config.py" command and returns user
data "shell_script" "merge_config" {
  lifecycle_commands {
    read = <<-EOF
#!/bin/bash
merge_config=$(${path.module}/merge_config.py --json '${local.json_raw}')
if [ $? -eq 0 ]
then
  echo "{\"config\": $merge_config}"
else
  echo "{\"config\": \"Error\"}"
fi
EOF
  }
}

locals {
  # Prepare raw data
  hcl_raw = {
    for config_name, config_value in var.raw_config:
      config_name => [
        for key, value in config_value:
          jsondecode("{\"${join("\":{\"", split(".", key))}\":${jsonencode(value)}${replace(join("}",range(length(split(".", key)))),"/[0-9]/","")}}")
      ]
  }

  hcl_merged = {
    for config_name in ["deployment", "service"]:
      #config_name => "'${jsonencode(concat(local.hcl_raw[config_name], [{config_name = local.config[config_name]}]))}'"
      config_name => flatten(concat(lookup(local.hcl_raw, config_name,[]), [lookup(local.config, config_name, [])]))
      if length(lookup(local.hcl_raw, config_name, [])) > 0 || length(lookup(local.config, config_name, {})) > 0
  }
  
  json_raw = "${jsonencode(local.hcl_merged)}"

  json_merged = data.shell_script.merge_config.output

  hcl_final_merged = jsondecode(local.json_merged["config"])
  
  
  config = {
    deployment = {
      metadata = {
        namespace = var.namespace
        name      = var.application_name
        labels    = merge(var.labels, {app = var.application_name})
      }

      spec = {
        replicas = var.replicas
        selector = {
          matchLabels  = merge(var.selectors_match_labels,{app = var.application_name})
        }

        template = {
          metadata = {
            labels = {
              app = var.application_name
            }
          }

          spec = {
            containers = [{
              image = var.container_image
              name  = var.application_name
            }]
          }
        }
      }
    }

    service = {
      metadata = {
        namespace = var.namespace
        name = var.application_name
      }
      spec = {
        selector = {app = var.application_name}
        
      }
    }//Service
  }


  
}

# Terraform module to utilize yaml fields in configuration.
module "k8s_yaml_tf" {
  module_enabled = var.module_enabled
  module_depends_on = var.module_depends_on
  source = "github.com/brcnblc/k8s-terraform-yaml" 
  appConfig = {
      "${var.namespace}-${var.application_name}" = {
        k8s = {
          for config_name, config_value in local.hcl_final_merged:
            config_name => config_value
        }
      } 
    }
}