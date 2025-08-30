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
  
  
resource "aws_instance" "bia-dev" {
  ami           = "ami-02f3f602d23f1659d"
  instance_type = "t3.micro"

  tags = {
    ambiente = "dev"
    Name = var.instance-name
    
  }
  vpc_security_group_ids = [aws_security_group.terra-sg.id]
}