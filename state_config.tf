terraform {
    backend "s3" {
        bucket = "onerbk-terraform-state"
        key    = "terraform.tfstate"
        region = "us-east-1"

    }
}