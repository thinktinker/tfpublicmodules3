### Objectives:
1. Using public terraform modules to deploy s3 bucket(s) - (main)
    - Runs on initial **`[main]`** branch 
    - deploys without considering `dev` | `prod` | `staging`
2. Using environment variables to define the dev, staging or production
    - Runs on **`[env-variables]`** branch
    - Refer to additions in `environment` folder (dev.tfvars, prod.tfvars, staging.tfvars)
    - Refer to addition `variables.tf`
    - Refer to updates to CD.yml where the environment profile is added to terraform plan
    - **Note:** This version still HAVE NOT ADOPTED env variable to deploy between `dev` | `prod` | `staging`
3. Applying environment variables to deploy between dev, staging or production
    - Runs on **`[cicd-updated-use-env-vars]`** branch
    - Updated `CD.yml` in folder `.github/workflows` to use the environment variables plan and apply
    - Updated `main.tf` to adopt the env variable "name_prefix" to update the environment to deploy (see code block below)

```
module "s3_bucket" {
    # Use a terraform public module
    source = "terraform-aws-modules/s3-bucket/aws" 

    # Provision a Bucket based on the chosen variable name_prefix
    bucket = "martin20sep2023-${var.name_prefix}-s3-public-mod-bucket"  
    versioning = {
        enabled = true
    }
}
```