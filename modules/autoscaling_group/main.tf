resource "aws_launch_configuration" "as_conf" {
  name          = "web_config"
  image_id      = var.image_id
  instance_type = var.instance_type
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

resource "aws_autoscaling_group" "nextcloud" {
  name                      = "foobar3-terraform-test"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true
  placement_group           = aws_placement_group.web.id
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = [aws_lb_target_group.test.arn]

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }

  timeouts {
    delete = "15m"
  }
}