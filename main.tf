## - Infrastructure as Code (IaC) using Terraform
terraform {
  backend "s3" {
    bucket         = "terraform-key-skills-tfstate"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-key-skills-tfstate"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = "Dev"
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source         = "./modules/vpc"
  project_name   = var.project_name
  vpc_cidr       = var.vpc_cidr
  subnet_cidr    = var.subnet_cidr
  ssh_cidr       = var.ssh_cidr
  http_cidr      = var.http_cidr
}

module "ec2" {
  source                = "./modules/ec2"
  project_name          = var.project_name
  instance_type         = var.instance_type
  key_name              = var.key_name
  subnet_id             = module.vpc.subnet_id
  security_group_id     = module.vpc.security_group_id
  iam_instance_profile  = module.cloudwatch.iam_instance_profile
}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
}

module "cloudwatch" {
  source           = "./modules/cloudwatch"
  project_name     = var.project_name
  environment      = "dev"
  log_retention_days = 7
  instance_id      = module.ec2.instance_id
  alarm_actions    = [] # Puedes agregar un ARN de SNS para notificaciones
}