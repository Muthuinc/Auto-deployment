terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# It takes the AWS cred from the Jenkins. 
# look at the top portion of jenkins file

provider "aws" {
  region = var.region
}

# VPC resource definition
resource "aws_vpc" "Isla_vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.vpc_instance_tenancy

  tags = {
    Name = var.vpc_name
  }
}

# Subnet - 1
resource "aws_subnet" "Public_1" {
  vpc_id     = aws_vpc.Isla_vpc.id
  cidr_block = var.sub1_cidr_block
  availability_zone = var.subnet1_availablity_zone
  tags = {
    Name = var.subnet1_name
  }
}

# Subnet creation -2

resource "aws_subnet" "Public_2" {
  vpc_id     = aws_vpc.Isla_vpc.id
  cidr_block = var.sub2_cidr_block
  availability_zone = var.subnet2_availablity_zone
  tags = {
    Name = var.subnet2_name
  }
}

# Subnet creation -3

resource "aws_subnet" "Public_3" {
  vpc_id     = aws_vpc.Isla_vpc.id
  cidr_block = var.sub3_cidr_block
  availability_zone = var.subnet3_availablity_zone
  tags = {
    Name = var.subnet3_name
  }
}

# Internet gateway

resource "aws_internet_gateway" "Pubgw" {
  vpc_id = aws_vpc.Isla_vpc.id

  tags = {
    Name = "Ig"
  }
}

#route table 

resource "aws_route_table" "Pubroute" {
  vpc_id = aws_vpc.Isla_vpc.id

  route {
    cidr_block = var.routetable
    gateway_id = aws_internet_gateway.Pubgw.id
  }
}

# route table association with subnets

resource "aws_route_table_association" "sub" {
  subnet_id      = aws_subnet.Public_1.id
  route_table_id = aws_route_table.Pubroute.id
}

resource "aws_route_table_association" "subb" {
  subnet_id      = aws_subnet.Public_2.id
  route_table_id = aws_route_table.Pubroute.id
}

resource "aws_route_table_association" "subbb" {
  subnet_id      = aws_subnet.Public_3.id
  route_table_id = aws_route_table.Pubroute.id
}

#Security groups 

resource "aws_security_group" "group1" {
  name        = "allow_tls"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.Isla_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.myip
  }
   ingress {
    description      = "TLS from VPC"
    from_port        = var.app_port
    to_port          = var.app_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  tags = {
    Name = var.secruity_group_name
  }
}

resource "aws_instance" "instance1" {
  ami                     = var.instance_ami
  instance_type           = var.instance_type
  subnet_id               = aws_subnet.Public_1.id
  vpc_security_group_ids  = [ aws_security_group.group1.id ]
  key_name                = var.key_name
  associate_public_ip_address = true
  tags = {
    Name = var.instance_tag
  }
}

#instance will be created

