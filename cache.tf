resource "aws_elasticache_replication_group" "nextcloud_redis" {
  replication_group_id       = "tf-redis-cluster"
  description                = "example description"
  node_type                  = "cache.t4g.micro"
  engine_version             = "7.1"
  port                       = 6379
  parameter_group_name       = "default.redis7.cluster.on"
  automatic_failover_enabled = true
  security_group_ids         = [aws_security_group.allow_all.id]
  subnet_group_name          = aws_elasticache_subnet_group.nextcloud_redis.name


  num_node_groups         = 2
  replicas_per_node_group = 1
}

resource "aws_elasticache_subnet_group" "nextcloud_redis" {
  name       = "nextcloud-redis"
  subnet_ids = module.subnet-us-east-1.public_subnet_ids

  tags = {
    Name = "My redis subnet group"
  }
}