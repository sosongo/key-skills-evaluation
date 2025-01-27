variable "project_name" {
  description = "The name of the project used for naming resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "ssh_cidr" {
  description = "CIDR block for SSH access"
  type        = string
}

variable "http_cidr" {
  description = "CIDR block to allow HTTP access"
  type        = string
}