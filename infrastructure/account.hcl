# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
locals {
  branch = {
    # ------- Main ----------

    # Template
    main = {
      account_name   = "main"
      aws_account_id = "592115245551"
      aws_profile    = "test-592115245551"
      bucket_suffix  = ""

      parameters = {
        DOMAIN         = "prod.bmdev.me"
        DNS_ZONE_ID    = "Z00140663TMWUSEB0C8DN"
        CLUSTER        = "main-production-cluster"
      }
    }

    # ------- BI ----------

    # BI Production 1
    bi_production_1 = {
      account_name   = "bi-production-1"
      aws_account_id = "592115245551"
      aws_profile    = "test-592115245551"
      bucket_suffix  = ""

      parameters = {
        DOMAIN         = "prod.bmdev.me"
        DNS_ZONE_ID    = "Z00140663TMWUSEB0C8DN"
        CLUSTER        = "main-production-cluster"
      }
    }
    
    # BI Production 2
    bi_production_2 = {
      account_name   = "bi-production-2"
      aws_account_id = "592115245551"
      aws_profile    = "test-592115245551"
      bucket_suffix  = ""

      parameters = {
        DOMAIN         = "prod.bmdev.me"
        DNS_ZONE_ID    = "Z00140663TMWUSEB0C8DN"
        CLUSTER        = "main-production-cluster"
      }
    }

    # BI Staging
    bi_staging = {
      account_name   = "bi-staging"
      aws_account_id = "592115245551"
      aws_profile    = "test-592115245551"
      bucket_suffix  = ""

      parameters = {
        DOMAIN         = "test.bmdev.me"
        DNS_ZONE_ID    = "Z00140663TMWUSEB0C8DN"
        CLUSTER        = "shared-testing-cluster"
      }
    }

  # ------- Application ----------

  # Application Production 1
    app_production_1 = {
      account_name   = "bi-production-1"
      aws_account_id = "592115245551"
      aws_profile    = "test-592115245551"
      bucket_suffix  = ""

      parameters = {
        DOMAIN         = "prod.bmdev.me"
        DNS_ZONE_ID    = "Z00140663TMWUSEB0C8DN"
        CLUSTER        = "main-production-cluster"
      }
    }
    
    # Application Production 2
    app_production_2 = {
      account_name   = "bi-production-2"
      aws_account_id = "592115245551"
      aws_profile    = "test-592115245551"
      bucket_suffix  = ""

      parameters = {
        DOMAIN         = "prod.bmdev.me"
        DNS_ZONE_ID    = "Z00140663TMWUSEB0C8DN"
        CLUSTER        = "main-production-cluster"
      }
    }

    # Application Staging
    app_staging = {
      account_name   = "bi-staging"
      aws_account_id = "592115245551"
      aws_profile    = "test-592115245551"
      bucket_suffix  = ""

      parameters = {
        DOMAIN         = "test.bmdev.me"
        DNS_ZONE_ID    = "Z00140663TMWUSEB0C8DN"
        CLUSTER        = "shared-testing-cluster"
      }
    }

  }
}
