data "aws_availability_zones" "available" {}

module "asg" {
  source        = "./modules/autoscaling_group"
  image_id      = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  subnet_ids    = module.subnet-us-east-1.public_subnet_ids
  lb_arn         = aws_lb.test.arn
  sg_id         = aws_security_group.allow_all.id
  vpc_id        = aws_vpc.nextcloud_vpc.id
  efs_id        = aws_efs_file_system.nextcloud_efs.id
  depends_on    = [aws_efs_mount_target.alpha]
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_all.id]
  subnets            = module.subnet-us-east-1.public_subnet_ids

  enable_deletion_protection = true
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


