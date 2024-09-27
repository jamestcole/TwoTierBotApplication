provider "aws" {
  region = "eu-west-1"  # Set the region to EU (Ireland)
}

# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

# Create a single public subnet in eu-west-1a
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-1a"  # Set to eu-west-1a
  tags = {
    Name = "public-subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main-gateway"
  }
}

# Create a route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Security Group for the EC2 Instances (App and DB)
resource "aws_security_group" "app_and_db_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere (consider restricting in production)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access from anywhere
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow MySQL access from anywhere (consider restricting in production)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "app_and_db_sg"
  }
}

# Create EC2 Instance for the App (in eu-west-1a)
resource "aws_instance" "app_server" {
  ami           = var.ec2_ami_id  # Ensure this variable is set to a valid AMI for eu-west-1
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = var.key_pair_name

  security_groups = [aws_security_group.app_and_db_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
             

