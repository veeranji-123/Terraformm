provider "aws" {
  region     = "us-west-1"
  access_key = "AKIAZEGRK4EUND5TN4CS"
  secret_key = "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"
}

#vpc.tf
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "newvpc"
  }
}

#creating subnet:
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  availability_zone = "us-west-1b"
  tags = {
    Name = "subnet1"
  }
}
#creating internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

#creating Route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "Route to internet"
  }
}

#Associating Route table
resource "aws_route_table_association" "subnet_assoc" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}
# Creating Security Group
resource "aws_security_group" "python_sg" {
  vpc_id = aws_vpc.main.id
  # Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 # Car-prediction access from anywhere
 ingress {
   from_port   = 8000
   to_port     = 8000
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
  # Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "python SG"
  }
}


# Defining CIDR Block for VPC
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
# Defining CIDR Block for Subnet
variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

# Creating EC2 instance
resource "aws_instance" "wordpress_instance" {
  ami                         = "ami-0fed225bf766d950c" # Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  count                       = 1
  key_name                    = "321321"
  vpc_security_group_ids      = ["${aws_security_group.python_sg.id}"]
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  user_data                   = file("userdata.sh")
  tags = {
    Name = "Python_Instance"
  }
}

output "public_ip" {
  value = aws_instance.wordpress_instance[*].public_ip
}
