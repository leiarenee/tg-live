# Override paramaters for your own account
# Dublicate this file and rename it as ".override.hcl"

locals {
  # On/Off - true if main config is to be overwritten with below parameters else branch name and account.hcl is used.
  override_active = true

  # Config name - Chose from below
  config = "<config_name>"

  # My Account
  <config_name> = {
    account_name   = "<aws_account_name>"
    aws_account_id = "<aws_account_id>"
    aws_profile    = "<aws-profile-name>"
    bucket_suffix  = "" 
    
    parameters = {
      DOMAIN         = "<sub_domain>.<domain>"
      DNS_ZONE_ID    = "<hosting_zone_id>"
      CLUSTER        = "<cluster-name>"
    }
  }

}