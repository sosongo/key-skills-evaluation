# DevOps Test: Key Skills Evaluation

## Overview
This project demonstrates the implementation of Infrastructure as Code (IaC), CI/CD pipeline automation, and monitoring for a basic web application deployed on AWS. Below is a detailed guide for setup, execution, and verification.

---

## Infrastructure as Code (IaC)

### **Provisioned Resources**
Using Terraform, the following AWS resources are created:
- **EC2 Instance**: Running Nginx as the web server.
- **Security Group**: Allows:
  - HTTP traffic on port `80`.
  - SSH traffic on port `22`.
- **S3 Bucket**: Configured for log storage with versioning enabled.

### **Steps to Deploy Infrastructure**
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Preview the changes:
   ```bash
   terraform plan -var="docker_image=<docker-hub-username>/my-web-app:latest"
   ```

4. Apply the changes:
   ```bash
   terraform apply -auto-approve -var="docker_image=<docker-hub-username>/my-web-app:latest"
   ```

### **Terraform Variables**
| Variable Name | Description                          |
|---------------|--------------------------------------|
| `docker_image` | Docker image to deploy on the EC2.   |
| `key_name`     | Name of the AWS key pair for SSH.    |

---

## CI/CD Pipeline Automation

### **Pipeline Overview**
The CI/CD pipeline automates the following steps:
1. **Source Stage**: Triggers on push events to the `main` branch.
2. **Build Stage**: Builds a Docker image of the web application.
3. **Deploy Stage**: Deploys the Docker image to the EC2 instance.

### **Pipeline Configuration**
- The pipeline uses **GitHub Actions**.
- Key stages include:
  - Building and pushing a Docker image to Docker Hub.
  - Deploying the image to an AWS EC2 instance using SSH.

### **Pipeline Setup**
1. Set the following secrets in GitHub:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `SSH_PRIVATE_KEY`
   - `DOCKER_USERNAME`
   - `DOCKER_PASSWORD`

2. The pipeline YAML file (`.github/workflows/deploy.yml`) is already configured to:
   - Build and push the Docker image.
   - Retrieve the EC2 public IP dynamically.
   - Deploy the containerized web application to the EC2 instance.

---

## Monitoring and Logging Setup

### **Monitoring**
- **Amazon CloudWatch** is configured to monitor:
  - **CPU Usage**: An alarm is triggered if usage exceeds `70%`.
  - **Instance Health**: Alarms notify if the instance becomes unhealthy.

### **Logging**
- **CloudWatch Logs** receives Nginx logs from the EC2 instance.
- A dedicated log stream is set up for application logs.

---

## Repository Structure
```


│
│
├── .github/workflows/
│   ├── deploy.yml             # GitHub Actions CI/CD pipeline


.
├── terraform/
├── Dockerfile                 # Dockerfile
├── backend-setup.tf           # Setup Backend Terraform
├── html                       # Web Code
│   ├── index.html
│   ├── script.js
│   └── style.css
├── modules                    # Modules Terraform
│   ├── cloudwatch
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── ec2
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── s3
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── scripts
│   └── init.sh                # Script Setup Virtual Machine
├── main.tf                    # Main Terraform configuration
└── variables.tf               # Input variables
├── outputs.tf                 # Output values
└── README.md                  # Project documentation
```

---