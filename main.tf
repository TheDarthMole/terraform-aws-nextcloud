data "aws_availability_zones" "available" {}

module "asg" {
  source                = "./modules/autoscaling_group"
  image_id              = "ami-0a3c3a20c09d6f377"
  instance_type         = "t2.micro"
  subnet_ids            = module.subnet-us-east-1.public_subnet_ids
  lb_arn                = aws_lb.test.arn
  sg_id                 = aws_security_group.allow_all.id
  vpc_id                = aws_vpc.nextcloud_vpc.id
  efs_id                = aws_efs_file_system.nextcloud_efs.id
  instance_profile_name = aws_iam_instance_profile.nextcloud_web_instance_profile.name
  depends_on            = [aws_efs_mount_target.alpha]

  s3_bucket_name   = aws_s3_bucket.nextcloud_s3.bucket
  s3_bucket_region = aws_s3_bucket.nextcloud_s3.region

  redis_host = aws_elasticache_replication_group.nextcloud_redis.configuration_endpoint_address


  postgres_db       = aws_db_instance.default.db_name
  postgres_user     = aws_db_instance.default.username
  postgres_password = "foobarbaz"
  postgres_host     = aws_db_instance.default.address

  nextcloud_admin_user     = "hello"
  nextcloud_admin_password = "hello"
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_all.id]
  subnets            = module.subnet-us-east-1.public_subnet_ids

  enable_deletion_protection = false
}

resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.nextcloud_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


