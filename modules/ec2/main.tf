## - Fetch the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

## - EC2 : Web Server
resource "aws_instance" "web_server" {
  # ami           = data.aws_ami.ubuntu.id
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [var.security_group_id]

  ## - Script : Install Docker and execute the image
  user_data = templatefile("${path.module}/../../scripts/init.sh", {
    DOCKER_IMAGE = var.docker_image
  })

  iam_instance_profile = var.iam_instance_profile # Agregado aquí

  tags = {
    Name = "WebServerInstance-${var.project_name}"
  }
}
