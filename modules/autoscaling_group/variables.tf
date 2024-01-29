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

variable "redis_host" {
  description = "The hostname of the Redis server to use for caching."
  type        = string
}

variable "redis_port" {
  description = "The port of the Redis server to use for caching."
  type        = number
  default     = 6379
}

variable "postgres_db" {
  description = "The name of the PostgreSQL database to use for the server."
  type        = string
}

variable "postgres_user" {
  description = "The username of the PostgreSQL user to use for the server."
  type        = string
}

variable "postgres_password" {
  description = "The password of the PostgreSQL user to use for the server."
  type        = string
}

variable "postgres_host" {
  description = "The hostname of the PostgreSQL server to use for the server."
  type        = string
}

variable "nextcloud_admin_user" {
  description = "The username of the Nextcloud admin user."
  type        = string
}

variable "nextcloud_admin_password" {
  description = "The password of the Nextcloud admin user."
  type        = string
}