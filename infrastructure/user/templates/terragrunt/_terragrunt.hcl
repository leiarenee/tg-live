# Local variable definitions
locals {
  global_replacements = jsondecode(file(find_in_parent_folders("replace.json")))
  local_replacements = jsondecode(file("replace.json"))
  replacements = merge(local.global_replacements, local.local_replacements)
}

# Module Source 
terraform {
  source = "${get_parent_terragrunt_dir()}/modules/<module_folder>"
}

# Shared TG file
include {
  path = find_in_parent_folders()
}

# Inputs to passed to the TF module
inputs = {
  replace_variables             = merge(local.replacements,{
    }
  )
}

# Dependecies without output
dependencies {
  paths = [""]
}

# Dependecy Blocks with outputs
dependency "<name>" {

}