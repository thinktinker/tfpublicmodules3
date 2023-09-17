module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"    # Use a terraform public module


  bucket = "martin17sep2023-s3-public-mod-bucket"  # Provision a Bucket with versioning
  versioning = {
    enabled = true
  }
}
