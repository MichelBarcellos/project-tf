terraform {
  
    required_providers {
            aws = {
                source  = "hashicorp/aws"
                version = "~> 4.0"
            }
        }
        required_version = ">= 1.2.0"
}

provider "aws" {
    region = "us-east-1"
    profile = "default"   
  
}


resource "aws_security_group" "terra-sg" {
  name        = "terra-sg"
  description = "regra sg projeto com tf"
  vpc_id      = "vpc-026959c74313e105b"


  ingress {
    description = "Liberado para o mundo"
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
 }
}
  
  
resource "aws_instance" "project-tf" {
  ami           = "ami-02f3f602d23f1659d"
  instance_type = "t3.micro"
  user_data = <<-EOF
#!/bin/bash

#Instalar Docker e Git
sudo yum update -y
sudo yum install git -y
sudo yum install docker -y
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker ssm-user
id ec2-user ssm-user
sudo newgrp docker

#Ativar docker
sudo systemctl enable docker.service
sudo systemctl start docker.service

#Instalar docker compose 2
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose


#Adicionar swap
sudo dd if=/dev/zero of=/swapfile bs=128M count=32
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile swap swap defaults 0 0" >> /etc/fstab


#Instalar node e npm
curl -fsSL https://rpm.nodesource.com/setup_21.x | sudo bash -
sudo yum install -y nodejs

#Configurar python 3.11 e uv para uso com mcp servers da aws
sudo dnf install python3.11 -y
sudo ln -sf /usr/bin/python3.11 /usr/bin/python3

curl -LsSf https://astral.sh/uv/install.sh | sh
              EOF

  tags = {
    ambiente = "dev"
    Name = var.instance-name
    
  }
  vpc_security_group_ids = [aws_security_group.terra-sg.id]
}