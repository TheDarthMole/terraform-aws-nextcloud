provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "available" {}

output "azs" {
  value = data.aws_availability_zones.available.names
}