# Create a VPC
resource "aws_vpc" "nextcloud_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    terraform = true
    Name      = "nextcloud"
  }
}

resource "aws_internet_gateway" "igw" {
  tags = {
    Name = "nextcloud-igw"
  }
  vpc_id = aws_vpc.nextcloud_vpc.id
}

module "subnet-us-east-1" {
  source              = "./modules/network"
  name                = "1"
  internet_gateway_id = aws_internet_gateway.igw.id
  private_subnet_cidrs = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
    "us-east-1c" = "10.0.3.0/24"
  }
  public_subnet_cidrs = {
    "us-east-1a" = "10.0.4.0/24"
    "us-east-1b" = "10.0.5.0/24"
    "us-east-1c" = "10.0.6.0/24"
  }
  region = "us-east-1"
  vpc_id = aws_vpc.nextcloud_vpc.id
}