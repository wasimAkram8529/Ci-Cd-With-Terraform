terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-for-collaboration"
    key = "remote-backend/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}