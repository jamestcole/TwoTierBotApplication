# AWS Region
variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "eu-west-2"
}

# VPC CIDR Block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Database variables
variable "db_name" {
  description = "Name of the RDS database"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "RDS database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS database password"
  type        = string
}

# Number of ECS instances (desired count)
variable "ecs_desired_count" {
  description = "Desired number of ECS instances"
  type        = number
  default     = 2
}

# Public Subnets for ECS Service
variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

# Security Group Ingress CIDR
variable "ingress_cidr" {
  description = "CIDR block allowed for inbound traffic (e.g., 0.0.0.0/0 for all IPs)"
  type        = string
  default     = "0.0.0.0/0"
}
