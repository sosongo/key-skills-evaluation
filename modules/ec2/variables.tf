variable "project_name" {
  description = "The name of the project used for naming resources"
  type        = string
}

variable "ami" {
  description = "Amazon Linux 2 (us-east-1)"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile for EC2"
  type        = string
}

variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string 
}

variable "docker_image" {
  description = "Docker image to deploy"
  type        = string 
  default     = "nginx:latest"
}