
# Configure the AWS Provider
provider "aws" {
  region = var.region_location
}

#configure the avaialability zones
data "aws_availability_zones" "available" {
  state = "available"
}



# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "vpcnew"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.example.id
  cidr_block = var.private_subnet_cidr
  availability_zone="ap-south-1a"

  tags = {
    Name = "subnet_private"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.example.id
  cidr_block = var.public_subnet_cidr
  availability_zone="ap-south-1a"

  tags = {
    Name = "subnet_public"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "eip_nat_gw" {
  domain = "vpc"
}



resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip_nat_gw.id
  subnet_id     = aws_subnet.private.id

  tags = {
    Name = "nat_gw"
  }

  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }


  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}


