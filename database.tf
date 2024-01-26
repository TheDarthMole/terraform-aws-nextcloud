resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = module.subnet-us-east-1.public_subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  username               = "nextcloud"
  password               = "foobarbaz"
  skip_final_snapshot    = true
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.allow_all.id]
}

