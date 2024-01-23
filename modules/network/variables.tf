variable "region" {
  description = "AWS Region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Public Subnet CIDRs"
  type        = map(string)
}

variable "private_subnet_cidrs" {
  description = "Private Subnet CIDRs"
  type        = map(string)
}

variable "name" {
  description = "Name of the subnet"
  type        = string
}

variable "internet_gateway_id" {
  description = "Internet Gateway ID"
  type        = string
}