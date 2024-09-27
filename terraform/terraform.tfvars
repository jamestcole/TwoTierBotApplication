aws_region         = "eu-west-1"        # Set to eu-west-1 (Ireland)
vpc_cidr           = "10.0.0.0/16"
ec2_instance_type  = "t2.micro"
key_pair_name      = "AIprojectkeyjamescole"    # Replace with your actual key pair name
ec2_ami_id         = "ami-0d729a60"     # Replace with the correct AMI ID for eu-west-1
ingress_cidr       = "0.0.0.0/0"        # Change this to restrict access if needed
