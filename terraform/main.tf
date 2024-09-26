provider "aws" {
  region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main-vpc"
  }
}

# Create two public subnets in different availability zones
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Create a route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }
}

resource "aws_route_table_association" "subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Security Group for the EC2 Instances (App and DB)
resource "aws_security_group" "app_and_db_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr]   # Allow SSH access
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr]   # Allow HTTP access (for the app)
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr]   # Allow MySQL access (for the database)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app_and_db_sg"
  }
}

# Create EC2 Instance for the App
resource "aws_instance" "app_server" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = var.key_pair_name

  security_groups = [aws_security_group.app_and_db_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "Hello, World from the App Server" > /var/www/html/index.html
              EOF

  tags = {
    Name = "App Server"
  }
}

# Create EC2 Instance for the MySQL Database
resource "aws_instance" "db_server" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.public_subnet_2.id
  key_name      = var.key_pair_name

  security_groups = [aws_security_group.app_and_db_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y mysql-server
              sudo systemctl start mysqld
              sudo systemctl enable mysqld
              mysql -u root -e "CREATE DATABASE finance_app;"
              mysql -u root -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'password';"
              mysql -u root -e "GRANT ALL PRIVILEGES ON finance_app.* TO 'admin'@'%';"
              EOF

  tags = {
    Name = "DB Server"
  }
}

# Associate Elastic IP for App and DB for easier access
resource "aws_eip" "app_eip" {
  instance = aws_instance.app_server.id
}

resource "aws_eip" "db_eip" {
  instance = aws_instance.db_server.id
}
