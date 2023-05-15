# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "VPC"
  }
}

# Get the value of the first public subnet
locals {
  first_private_subnet = element(keys(var.private_subnets), 0)
}

# Public Subnets
resource "aws_subnet" "public_subnets" {
  for_each          = var.public_subnets
  cidr_block        = each.value
  availability_zone = each.key
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "Public Subnet - ${each.key}"
  }
}

# Private Subnets
resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  cidr_block        = each.value
  availability_zone = each.key
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "Private Subnet - ${each.key}"
  }
}


# Internet Gateway for the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Main IGW"
  }
}

# NAT Gateway for the public subnet
resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natgw" {
  subnet_id     = aws_subnet.public_subnets[local.first_private_subnet].id
  allocation_id = aws_eip.eip.id
  tags = {
    Name = "NAT Gateway"
  }
  depends_on = [aws_eip.eip]
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Public Route Table"
  }
}

# Route the public subnet traffic through the Internet Gateway
resource "aws_route" "public_igw_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public_route_table_association" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

# Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Private Route Table"
  }
}

# Route the private subnet traffic through the NAT Gateway
resource "aws_route" "nat-ngw-route" {
  route_table_id         = aws_route_table.private_route_table.id
  nat_gateway_id         = aws_nat_gateway.natgw.id
  destination_cidr_block = "0.0.0.0/0"
}

# Associate the private subnet with the private route table
resource "aws_route_table_association" "private_route_table_association" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}
