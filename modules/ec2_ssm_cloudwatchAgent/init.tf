provider "aws" {
  region  = data.terraform_remote_state.backend.outputs.region
  profile = var.profile

}

# terraform {
#   backend "s3" {
#       bucket = "aramis-terraform-backend"
#       key = "tfstate/ec2_ssm_cloudwatchAgent/terraform.tfstate"
#       region = "eu-west-1"
#       encrypt = true
#       kms_key_id = "alias/terraform-bucket-kms-key"
#       dynamodb_table = "terraform-state"
#       profile = "aramis"
#   }
# }

data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket     = "aramis-terraform-backend"
    key        = "tfstate/backend/terraform.tfstate"
    region     = "eu-west-1"
    kms_key_id = "alias/terraform-bucket-kms-key"
    profile    = "aramis"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket     = "aramis-terraform-backend"
    key        = "tfstate/vpc/terraform.tfstate"
    region     = "eu-west-1"
    kms_key_id = "alias/terraform-bucket-kms-key"
    profile    = "aramis"
  }
}


