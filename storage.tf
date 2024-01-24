resource "aws_efs_file_system" "nextcloud_efs" {
  creation_token = "nextcloud-efs"
  encrypted = true


  tags = {
    Name = "nextcloud-efs"
  }
}

