variable "terraform_bucket" {
  description = "Terraform Bucket Name"
  type        = string
  default     = "terraform-key-skills-tfstate"
}

variable "project_name" {
  description = "The name of the project used for naming resources"
  type        = string
  default     = "key-skills-evaluation"
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "key_name" {
  description = "Name of the existing key pair to use for the EC2 instance"
  type        = string
}

variable "ssh_cidr" {
  description = "CIDR block allowed for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "http_cidr" {
  description = "CIDR block to allow HTTP access (default: open to all)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ssh_private_key_path" {
  description = "Path SSH Key Pair"
  type        = string
  default     = "~/.ssh/cli-sosongo-key-pair-name.pem"
  }

variable "docker_image" {
  description = "Docker image to deploy"
  type        = string
  default     = "sosongo/my-web-app:latest"
}