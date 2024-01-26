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

variable "lb_arn" {
  description = "The ARN of the load balancer to which to attach the server."
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

variable "efs_id" {
  description = "The id of the EFS volume to mount on the servers."
  type        = string
}

variable "instance_profile_name" {
  description = "The name of the instance profile to attach to the server."
  type        = string
}

variable "s3_bucket_name" {
    description = "The name of the S3 bucket to which to attach the nextcloud server."
    type        = string
}

variable "s3_bucket_region" {
    description = "The region of the S3 bucket to which to attach the nextcloud server."
    type        = string
}