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
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "my-vpc"
  cidr = "00101010101"
  
}


resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-michel"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}