resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags =  merge(local.common_tags, { Name = replace(local.Name, "rtype", "vpc-main") })
  }

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(local.common_tags, { Name = replace(local.Name, "rtype", "igw-main") })
  }

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = merge(local.common_tags, { Name = replace(local.Name, "rtype", "pubroute-main") })
  }


resource "aws_subnet" "pub_sub_1" {
  count = length(var.pub_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.pub_cidr_blocks, count.index)

  tags = merge(local.common_tags, { Name = replace(local.Name, "rtype", "pubsub-main") })
  }



resource "aws_main_route_table_association" "a" {
  route_table_id = aws_route_table.public_route.id
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "a" {
  count = length(var.route_table_associations)
  subnet_id      = element(var.route_table_associations,count.index)
  route_table_id = aws_route_table.public_route.id
}

resource "aws_eip" "nat_gateway_eip" {
  vpc      = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.pub_sub_1[0].id
  tags = merge(local.common_tags, { Name = replace(local.Name, "rtype", "nat-main") })
  }


resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  route {
    gateway_id = aws_nat_gateway.nat_gateway.id
    cidr_block = "0.0.0.0/0"
  }

  tags = merge(local.common_tags, { Name = replace(local.Name, "rtype", "privroute-main") })
  }


resource "aws_subnet" "priv_sub_1" {
  count = length(var.priv_cidr_blocks)
  vpc_id     = aws_vpc.main.id
  cidr_block = element(var.priv_cidr_blocks, count.index)

  tags = merge(local.common_tags, { Name = replace(local.Name, "rtype", "privsub-main") })
  }


resource "aws_route_table_association" "b" {
  count = length(var.aws_subnet_priv_subs)
  subnet_id      = element(var.aws_subnet_priv_subs, count.index)
  route_table_id = aws_route_table.private_route.id
}
