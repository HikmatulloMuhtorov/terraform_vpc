resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = format("%s-vpc",var.env)
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-igw",var.env)
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    gateway_id = aws_internet_gateway.igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = format("%s-pub-route",var.env)
  }
}

resource "aws_subnet" "pub_sub_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = format("%s-pub-sub1",var.env)
  }
}

resource "aws_subnet" "pub_sub_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = format("%s-pub-sub2",var.env)
  }
}

resource "aws_subnet" "pub_sub_3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = format("%s-pub-sub3",var.env)
  }
}

resource "aws_main_route_table_association" "a" {
  route_table_id = aws_route_table.public_route.id
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub_sub_1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.pub_sub_2.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.pub_sub_3.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_eip" "nat_gateway_eip" {
  vpc      = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.pub_sub_1.id

  tags = {
    Name = format("%s-nat-gateway",var.env)
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  route {
    gateway_id = aws_nat_gateway.nat_gateway.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = format("%s-priv-route",var.env)
  }
}

resource "aws_subnet" "priv_sub_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.11.0/24"

  tags = {
    Name = format("%s-priv-sub1",var.env)
  }
}

resource "aws_subnet" "priv_sub_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.12.0/24"

  tags = {
    Name = format("%s-priv-sub2",var.env)
  }
}

resource "aws_subnet" "priv_sub_3" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.13.0/24"

  tags = {
    Name = format("%s-priv-sub3",var.env)
  }
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.priv_sub_1.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "e" {
  subnet_id      = aws_subnet.priv_sub_2.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "f" {
  subnet_id      = aws_subnet.priv_sub_3.id
  route_table_id = aws_route_table.private_route.id
}
