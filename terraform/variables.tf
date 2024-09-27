# AWS Region
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

# VPC CIDR
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"  # Default VPC CIDR
}

# EC2 Instance Type
variable "ec2_instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t2.micro"  # Default instance type
}

# EC2 AMI ID
variable "ec2_ami_id" {
  description = "The AMI ID for launching EC2 instances"
  type        = string
}

# SSH Key Pair
variable "key_pair_name" {
  description = "The name of the SSH key pair to access the EC2 instances"
  type        = string
}

# Ingress CIDR (for SSH, HTTP, MySQL access)
variable "ingress_cidr" {
  description = "CIDR block allowed for inbound traffic (e.g., 0.0.0.0/0 for open access)"
  type        = string
}
