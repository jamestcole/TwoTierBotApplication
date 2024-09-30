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
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"  # Set to eu-west-1a
  map_public_ip_on_launch = true      # Crucial for assigning public IPs
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
  # Allow inbound traffic on port 5000 for the Flask app
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow access from anywhere (consider restricting in production)
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
  associate_public_ip_address = true  # Ensure public IP association
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.app_and_db_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y apache2 git python3-pip python3-venv mariadb-client libapache2-mod-wsgi-py3
              #Clone your GitHub repository
              git clone https://github.com/jamestcole/TwoTierBotApplication.git /var/www/html/app
              
              cp /var/www/html/app/terraform/apache-config/app.conf /etc/apache2/sites-available/app.conf
              # Setup Python virtual environment
              cd /var/www/html/app
              sudo python3 -m venv venv
              sudo chown -R ubuntu:ubuntu /var/www/html/app/venv
              source venv/bin/activate
              pip install -r requirements.txt
              
              # Start the Flask app
              nohup flask run --host=0.0.0.0 --port=5000 &

              a2ensite app.conf
              sudo a2enmod proxy
              sudo a2enmod proxy_http
              sudo systemctl start apache2
              sudo systemctl enable apache2

              # Set Flask app to run on startup
              echo "@reboot cd /var/www/html/app && source venv/bin/activate && nohup flask run --host=0.0.0.0 --port=5000 &" | crontab -

              # Change DocumentRoot in Apache configuration
              # sudo sed -i 's|DocumentRoot .*|DocumentRoot /var/www/html/app/app/static|' /etc/apache2/sites-available/000-default.conf
              # sudo systemctl restart apache2
              # ensure apache2 server serves the application
              sudo ln -s /var/www/html/app/app/static/index.html /var/www/html/index.html
              EOF

  tags = {
    Name = "App Server"
  }
}

# Create EC2 Instance for the MySQL Database (in the same subnet as the app)
resource "aws_instance" "db_server" {
  ami           = var.ec2_ami_id  # Ensure you have the correct AMI ID
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.public_subnet.id
  associate_public_ip_address = true  # Ensure public IP association
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.app_and_db_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y mysql-server git
              sudo systemctl start mysql
              sudo systemctl enable mysql
              # Clone your GitHub repository
              git clone https://github.com/jamestcole/TwoTierBotApplication.git /tmp/repo
              mysql -u root < /tmp/repo/db/setup.sql
              mysql -u root -e "CREATE DATABASE finance_app;"
              mysql -u root -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'password';"
              mysql -u root -e "GRANT ALL PRIVILEGES ON finance_app.* TO 'admin'@'%';"
              mysql -u root -e "FLUSH PRIVILEGES;"

              # Import the SQL file from the repo
              mysql -u root finance_app < /tmp/repo/db/setup.sql
              EOF

  tags = {
    Name = "DB Server"
  }
}
