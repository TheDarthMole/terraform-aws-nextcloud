variable "image_id" {
  description = "The ID of the AMI to use for the server."
  type        = string
}

variable "instance_type" {
  description = "The type of instance to start."
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets in which to place the server."
  type        = list(string)
}

variable "lb_id" {
  description = "The ID of the load balancer to which to attach the server."
  type        = string
}

variable "sg_id" {
  description = "The ID of the security group to which to attach the server."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC in which to place the server."
  type        = string
}