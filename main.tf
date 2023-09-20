module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"    # Use a terraform public module


  bucket = "martin20sep2023-${var.name_prefix}-s3-public-mod-bucket"  # Provision a Bucket with versioning
  versioning = {
    enabled = true
  }
}
