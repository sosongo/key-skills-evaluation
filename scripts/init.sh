#!/bin/bash
set -euo pipefail

## - Logs
LOG_FILE="/var/log/user-data.log"
ERROR_LOG_FILE="/var/log/user-data-error.log"

{
  echo "### - Starting user data script - ###"
  
  ## - Actualizamos y configuramos el sistema
  echo "Updating and upgrading system packages..."
  yum update -y

  ## - Instalamos Docker
  echo "Installing Docker..."
  amazon-linux-extras enable docker
  amazon-linux-extras install docker -y

  ## - Iniciamos el servicio Docker
  echo "Starting Docker service..."
  systemctl start docker
  systemctl enable docker

  ## - Ejecutamos la imagen Docker
  echo "Running Docker container from image '{{DOCKER_IMAGE}}'..."
  docker run -d -p 80:80 {{DOCKER_IMAGE}}

  echo "### - Script completed successfully - ###"
} >> $LOG_FILE 2>> $ERROR_LOG_FILE || {
  echo "### - An error occurred during execution - ###" >> $ERROR_LOG_FILE
  exit 1
}
