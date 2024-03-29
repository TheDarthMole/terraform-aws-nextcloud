resource "aws_efs_file_system" "nextcloud_efs" {
  creation_token = "nextcloud-efs"
  encrypted      = true


  tags = {
    Name = "nextcloud-efs"
  }
}

resource "aws_efs_mount_target" "alpha" {
  count           = length(module.subnet-us-east-1.private_subnet_ids)
  file_system_id  = aws_efs_file_system.nextcloud_efs.id
  subnet_id       = module.subnet-us-east-1.private_subnet_ids[count.index]
  security_groups = [aws_security_group.allow_all.id]
}

resource "aws_s3_bucket" "nextcloud_s3" {
  force_destroy = true
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.nextcloud_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}
