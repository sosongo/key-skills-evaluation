## - Infrastructure as Code (IaC) using Terraform
terraform {
  backend "s3" {
    bucket         = "terraform-key-skills-tfstate"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
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