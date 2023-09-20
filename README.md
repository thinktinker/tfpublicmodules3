### Objectives:
#
1. Using public terraform modules to deploy s3 bucket(s) - (main)
    - Runs on initial **`[main]`** branch 
    - deploys without considering `dev` | `prod` | `staging`
#
2. Using environment variables to define the dev, staging or production
    - Runs on **`[env-variables]`** branch
    - Refer to additions in `environment` folder (dev.tfvars, prod.tfvars, staging.tfvars)
    - Refer to addition `variables.tf`
    - Refer to updates to CD.yml where the environment profile is added to terraform plan
    - **Note:** This version still HAVE NOT ADOPTED env variable to deploy between `dev` | `prod` | `staging`
#
3. Applying environment variables to deploy between dev, staging or production
    - Runs on **`[cicd-updated-use-env-vars]`** branch
    - Updated `CD.yml` in folder `.github/workflows` to use the environment variables plan and apply
    - Updated `main.tf` to adopt the env variable "name_prefix" to update the environment to deploy (see code block below)
    - **Note 1:** This version overrides the last deployment as `dev` | `prod` | `staging` uses the same tfstate file. 
    - **Note 2:** Refer to **`step 4`** to create independent state files to have independent deployments
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
#
4. Applying environment variables to deploy **DIFFERENT TFSTATES**
    - Runs on **`[update-backend-adopting-different-tfstates]`** branch
    - `backend.tf` will need to refer to github environment variables to perform the deployment switch
        - This is because backend does not accept terraform variables
        - Run the following command in `CD.yml` to update the tfstate file for each deployment (dev,staging prod)
        - 's/martin20sep2023/${{ github.event.inputs.environment }}martin20sep2023/' backend.tf
```
##CD
# Update backend.tf to host an independent .tfstate file for each deployment
- name: Replace Backend File
run: sed 's/martin20sep2023/${{ github.event.inputs.environment }}-martin20sep2023/' backend.tf

- name: Initialize Terraform
run: terraform init
    
# Updated to use the environment variables for both plan and apply
- name: Terraform Plan
run: terraform plan -var-file="environment/${{ github.event.inputs.environment }}.tfvars"

- name: Terraform Apply
run: terraform apply -var-file="environment/${{ github.event.inputs.environment }}.tfvars" --auto-approve
```