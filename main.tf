terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Input variables for flexibility
variable "aws_region" {
  type        = string
  description = "AWS region for deployment"
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

# Fetch the default VPC to deploy resources into
data "aws_vpc" "default" {
  default = true
}

# Create a Security Group allowing SSH (Port 22) and all outbound traffic
resource "aws_security_group" "linux_sg" {
  name        = "linux-server-sg"
  description = "Allow inbound SSH and full outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Best practice: restrict this to your specific IP address
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "linux-server-sg"
  }
}

# Provision the Linux EC2 Instance
resource "aws_instance" "linux_server" {
  ami                    = "ami-041607313c6a2a618" # Amazon Linux 2023 AMI (Verify for your selected region)
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.linux_sg.id]

  tags = {
    Name = "TerraformLinuxServer"
  }
}

# Output the Public IP address of the server
output "instance_public_ip" {
  description = "Public IP address of the deployed Linux server"
  value       = aws_instance.linux_server.public_ip
}
