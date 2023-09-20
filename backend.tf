terraform {
  backend "s3" {
    bucket = "martin-cicd-state-bucket"
    key    = "martin20sep2023-s3-public-mod.tfstate"
    region = "us-east-1"
  }
}