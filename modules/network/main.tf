data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_internet_gateway" "igw" {
  internet_gateway_id = var.internet_gateway_id
}

#################
# Subnets
#################

resource "aws_subnet" "public" {
  for_each                                    = var.public_subnet_cidrs
  vpc_id                                      = data.aws_vpc.vpc.id
  cidr_block                                  = each.value
  availability_zone                           = each.key
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    terraform = true
    Name      = "${data.aws_vpc.vpc.tags["Name"]}-subnet-public${var.name}-${each.key}"
  }
}

resource "aws_subnet" "private" {
  for_each                                    = var.private_subnet_cidrs
  vpc_id                                      = data.aws_vpc.vpc.id
  cidr_block                                  = each.value
  availability_zone                           = each.key
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    terraform = true
    Name      = "${data.aws_vpc.vpc.tags["Name"]}-subnet-private${var.name}-${each.key}"
  }
}

#################
# Route Tables
#################

resource "aws_route_table" "public_route_table" {
  vpc_id = data.aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  for_each       = var.public_subnet_cidrs
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each       = var.private_subnet_cidrs
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private_route_table.id
}

#################
# Network ACLs
#################

resource "aws_network_acl" "public" {
  vpc_id = data.aws_vpc.vpc.id
  subnet_ids = [
    for subnet in merge(aws_subnet.public, aws_subnet.private) : subnet.id
  ]
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_network_acl" "private" {
  vpc_id = data.aws_vpc.vpc.id
  subnet_ids = [
    for subnet in aws_subnet.private : subnet.id
  ]
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}
