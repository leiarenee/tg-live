# Override paramaters for your own account
# Dublicate this file and rename it as ".override.hcl"

locals {
  # On/Off - true if main config is to be overwritten with below parameters else branch name and account.hcl is used.
  override_active = true

  # Config name - Chose from below
  config = "<my_name>"

  # My Account
  <my_name> = {
    account_name   = "<my_name>"
    aws_account_id = "<my_aws_account_id>"
    aws_profile    = "<my_name-my_aws_account_id>"
    bucket_suffix  = "" 
    
    parameters = {
      DOMAIN         = "<my_name>.<my_domain>"
      DNS_ZONE_ID    = "<my_hosting_zone_id>"
      CLUSTER        = "<my-cluster-name>"
    }
  }

}