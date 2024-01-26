resource "aws_launch_template" "as_conf" {
  name_prefix            = "web_config"
  image_id               = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  iam_instance_profile {
    name = var.instance_profile_name
  }


  user_data = base64encode(<<-EOF
#!/bin/bash
sudo yum update
sudo yum install docker amazon-efs-utils -y
sudo systemctl enable docker
sudo systemctl start docker

sudo mkdir -p /mnt/efs/fs1
sudo mount -t efs -o tls ${var.efs_id}:/ /mnt/efs/fs1

sudo docker run -d \
-v /mnt/efs/fs1/:/var/www/html \
-p 80:80 \
-e 'OBJECTSTORE_S3_BUCKET=${var.s3_bucket_name}' \
-e 'OBJECTSTORE_S3_REGION=${var.s3_bucket_region}' \
-e 'NEXTCLOUD_TRUSTED_DOMAINS=*' \
--name nextcloud \
nextcloud:28.0.1-apache
              EOF
  )
}

resource "aws_security_group" "web_sg" {
  vpc_id = var.vpc_id

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

resource "aws_placement_group" "web" {
  name     = "hunky-dory-pg"
  strategy = "spread"
}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "nextcloud_front_end" {
  load_balancer_arn = var.lb_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_autoscaling_group" "nextcloud" {
  name                      = "nextcloud-web-asg"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
  placement_group           = aws_placement_group.web.id
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [aws_lb_target_group.test.arn]

  launch_template {
    id      = aws_launch_template.as_conf.id
    version = "$Latest"
  }

  instance_maintenance_policy {
    min_healthy_percentage = 30
    max_healthy_percentage = 120
  }

  timeouts {
    delete = "15m"
  }
}