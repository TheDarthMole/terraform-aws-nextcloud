resource "aws_efs_file_system" "nextcloud_efs" {
  creation_token = "nextcloud-efs"
  encrypted = true


  tags = {
    Name = "nextcloud-efs"
  }
}

resource "aws_efs_mount_target" "alpha" {
  for_each = toset(module.subnet-us-east-1.private_subnet_ids)
  file_system_id = aws_efs_file_system.nextcloud_efs.id
  subnet_id      = each.value
  security_groups = [aws_security_group.allow_all.id]
}