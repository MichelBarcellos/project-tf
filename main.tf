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
    profile = ""   
  
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}
output "instance_id" {
  value = aws_instance.example.id
}
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}