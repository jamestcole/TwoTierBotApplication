# Terraform AWS Infrastructure for EC2-Based App and MySQL Database
This repository contains Terraform configurations to deploy an application and MySQL database on separate EC2 instances in AWS. The infrastructure includes a VPC, subnets, security groups, and Elastic IPs to allow public access. The project is set up for the EU (London) region.

## Architecture
VPC: A virtual private cloud that hosts your resources.
Subnets: Two public subnets, one for the app and one for the database.
Security Groups: Control access for SSH, HTTP, and MySQL.
EC2 Instances:
App Server: Runs a simple web server (httpd) that can be extended with Docker later.
Database Server: Runs a MySQL database with a preconfigured user and database.
Prerequisites
Before running this project, make sure you have the following:

## AWS Account with programmatic access enabled.
AWS CLI installed and configured with your credentials:
bash
Copy code
aws configure
Terraform installed. Follow the installation guide here.
SSH Key Pair created in the eu-west-2 region (UK):
You can create an SSH Key Pair in the AWS Management Console under EC2 > Key Pairs.
Replace your-key-pair in the terraform.tfvars file with your key name.
Variables
These are the key variables used in the configuration:

```
AWS Region: Set to eu-west-2 (London) by default.
VPC CIDR: Set to 10.0.0.0/16 for your VPC's IP range.
EC2 Instance Type: Set to t2.micro for free-tier eligibility.
AMI: Using Amazon Linux 2 AMI for the eu-west-2 region (ami-0d729a60).
Key Pair: Your SSH key pair name for connecting to the EC2 instances.
```

## File Structure

```
Copy code
├── main.tf                # Defines the AWS infrastructure (EC2, VPC, Security Groups, etc.)
├── outputs.tf             # Outputs the public IP addresses of the EC2 instances
├── provider.tf            # Configures the AWS provider
├── terraform.tfvars       # Specifies variable values (region, AMI, instance types, key pair)
├── variables.tf           # Defines variables for use in the Terraform configuration
└── README.md              # Project documentation
```

## Configuration

Update the terraform.tfvars file with the necessary values, including your SSH key pair name and ensure the AMI ID is correct for the eu-west-2 region.

Example terraform.tfvars:

hcl
Copy code
aws_region         = "eu-west-2"          # UK Region (London)
vpc_cidr           = "10.0.0.0/16"
ec2_instance_type  = "t2.micro"
key_pair_name      = "your-key-pair"      # Your SSH key pair for eu-west-2
ec2_ami_id         = "ami-0d729a60"       # Amazon Linux 2 AMI for eu-west-2
ingress_cidr       = "0.0.0.0/0"          # Open access (restrict as needed)
Deploying the Infrastructure
Initialize Terraform: This sets up Terraform in your project directory.

bash
```
terraform init
```
Plan the Infrastructure: This step creates an execution plan, showing you the resources that will be created.

bash
```
terraform plan -var-file="terraform.tfvars"
```
Apply the Configuration: This step actually creates the AWS resources defined in main.tf.

bash

```
terraform apply -var-file="terraform.tfvars"
```
After applying, Terraform will output the public IP addresses of both EC2 instances (App and Database).

Access the Instances:

You can SSH into your EC2 instances using the provided Elastic IPs:
bash
Copy code
ssh -i your-key.pem ec2-user@<app-server-public-ip>
ssh -i your-key.pem ec2-user@<db-server-public-ip>
Clean Up: When you're done testing, you can destroy the infrastructure:

bash
```
terraform destroy -var-file="terraform.tfvars"
```
Accessing the App and Database
App Server: Visit the public IP of your app server in a browser (e.g., http://<app-server-public-ip>) to see the "Hello, World" page.
Database Server: Connect to the MySQL database via the MySQL client, using the public IP of the database server:
bash
Copy code
mysql -h <db-server-public-ip> -u admin -p
Future Enhancements
Docker Setup: In the next phase, you can install Docker on the app EC2 instance and containerize the application.
Scaling: Consider adding an Auto Scaling Group and Elastic Load Balancer (ALB) for high availability.
RDS: Later, you may replace the EC2-based database with Amazon RDS for better management and scalability.