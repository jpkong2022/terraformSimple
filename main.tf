terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws = "~> 3.0"
  }
}

provider "aws" {
	region = var.region
	access_key = var.access_key
	secret_key = var.secret_key
}

resource "aws_instance" "default" {
  ami = var.ami
  instance_type = var.instance_type
  
}

data "aws_vpc" "default" {
  default = true
}


resource "aws_security_group" "mysg" {
  
  description = "security group for private network access"
  vpc_id      = "${data.aws_vpc.default.id}"

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


