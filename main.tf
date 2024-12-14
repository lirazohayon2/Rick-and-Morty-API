# Provider Configuration - AWS
provider "aws" {
  region  = "us-east-1"  # Set to Free Tier eligible region
}

# VPC Configuration - Creating a Virtual Private Cloud (VPC)
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"  # CIDR block for the VPC
}

# Subnet Configuration - Creating a Subnet within the VPC
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id  # Associate subnet with the VPC
  cidr_block        = "10.0.1.0/24"        # CIDR block for the subnet
  availability_zone = "us-east-1a"         # Set availability zone
}

# Internet Gateway - Allows VPC access to the internet
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id  # Attach Internet Gateway to the VPC
}

# Route Table - Route table for directing internet traffic
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id  # Associate route table with the VPC

  # Route for directing all IPv4 traffic to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"                      # Route all IPs
    gateway_id = aws_internet_gateway.main_igw.id  # Route to the Internet Gateway
  }
}

# Route Table Association - Link the route table to the subnet
resource "aws_route_table_association" "main_route_table_association" {
  subnet_id      = aws_subnet.main_subnet.id       # Associate with subnet
  route_table_id = aws_route_table.main_route_table.id  # Link to route table
}

# Security Group - Define security rules for the EC2 instance
resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.main_vpc.id  # Attach security group to the VPC

  # Inbound rule for SSH access (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow from any IP (for demo purposes)
  }

  # Inbound rule for HTTP access on port 5000 (application)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow from any IP (for application access)
  }

  # Outbound rule to allow all traffic to leave the instance
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AppSecurityGroup"  # Tag for easy identification
  }
}

# EC2 Instance - Application Server with Docker setup
resource "aws_instance" "app_server" {
  ami = "ami-0ddc798b3f1a5117e"  # Common Amazon Linux 2 AMI for us-east-1
  instance_type = "t2.micro"               # Free-tier eligible instance type
  subnet_id     = aws_subnet.main_subnet.id  # Place instance in the created subnet
  associate_public_ip_address = true  # Ensure public IP association
#   key_name               = "rick-and-morty-key-new" # Use the new key name

  # Attach Security Group to EC2
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  # User data script to install Docker and run the application
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install docker -y
              sudo service docker start
              sudo usermod -a -G docker ec2-user
              docker run -d -p 5000:5000 rick_and_morty_api:latest
              EOF

  tags = {
    Name = "RickAndMortyAppServer"  # Tag for easy identification
  }
}

# Output the public IP of the EC2 instance for easy access to the application
output "app_server_public_ip" {
  description = "The public IP of the application server"
  value       = aws_instance.app_server.public_ip
}

# # Add the SSH key pair resource here
# resource "aws_key_pair" "rick_and_morty_key_new" {
#   key_name   = "rick-and-morty-key-new"            # Name of the key pair
#   public_key = file("~/.ssh/rick-and-morty-key-new.pub")  # Path to the public key file
# }
