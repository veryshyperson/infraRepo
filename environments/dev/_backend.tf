terraform {
  backend "s3" {
    bucket         = "ran-module-tfstate"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-module-tfstate-lock"
  }
}