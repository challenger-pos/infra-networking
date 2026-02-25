terraform {
  backend "s3" {
    bucket         = "tf-state-challenge-bucket"
    key            = "v4/networking/production/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
  }
}