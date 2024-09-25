provider "aws" {
  region = "us-west-2"
}

# ECS Cluster
resource "aws_ecs_cluster" "app-cluster" {
  name = "app-cluster"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app-task" {
  family                = "app-task"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  cpu                   = "256"
  memory                = "512"
  container_definitions = <<DEFINITION
  [
    {
      "name": "app-container",
      "image": "nginx",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ]
    }
  ]
  DEFINITION
}

# ECS Service
resource "aws_ecs_service" "app-service" {
  name            = "app-service"
  cluster         = aws_ecs_cluster.app-cluster.id
  task_definition = aws_ecs_task_definition.app-task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.app-subnet[*].id
    security_groups  = [aws_security_group.app-sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app-tg.arn
    container_name   = "app-container"
    container_port   = 80
  }
}

# Load Balancer
resource "aws_lb" "app-lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app-sg.id]
  subnets            = aws_subnet.app-subnet[*].id
}

# Load Balancer Target Group
resource "aws_lb_target_group" "app-tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app-vpc.id
}

# Load Balancer Listener
resource "aws_lb_listener" "app-listener" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.app-tg.arn
    type             = "forward"
  }
}

# VPC, Subnets, and Security Group
resource "aws_vpc" "app-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "app-subnet" {
  count = 2
  vpc_id = aws_vpc.app-vpc.id
  cidr_block = "10.0.${count.index}.0/24"
}

resource "aws_security_group" "app-sg" {
  vpc_id = aws_vpc.app-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Database
resource "aws_db_instance" "app-db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "appdb"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.app-sg.id]
  db_subnet_group_name = aws_db_subnet_group.db-subnet-group.name
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.app-subnet[*].id
}
