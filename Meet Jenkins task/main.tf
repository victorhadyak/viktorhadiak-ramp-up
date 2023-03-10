# Define the VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Jenkins_VPC"
  }
}

# Define the subnet within the VPC
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.a_zone
  tags = {
    Name = "Jenkins_Subnet"
  }
}

# Define the Internet Gateway for the VPC
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "Jenkin_IGW"
  }
}

# Define the Route Table for the VPC
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  # Add a route to the Internet Gateway for all traffic
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "Jenkins_RouteTable"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Define the EC2 instance
resource "aws_instance" "ramp_up_jenkins" {
  ami                    = var.ami
  instance_type          = var.ec2_type
  vpc_security_group_ids = [aws_security_group.my_jenkins.id]
  availability_zone      = var.a_zone
  key_name               = "my_key"
	user_data              = "${file("source/script.sh")}"
	tags                   = {
		Name           = "debian-jenkins"
	}
}

# Define the Security Group for the instance
resource "aws_security_group" "my_jenkins" {
  name        = "debian jenkins"
  description = "Security group for jenkins server"

  ingress {
    description = "Allow all traffic through port 8080"
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = [var.my_jenkins_cidr_block]
  }
  
  ingress {
    description = "Allow SSH traffic through port 22"
    from_port   = "22"	
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [var.my_jenkins_cidr_block]
  }
  
  egress {
    description = "Allow all outbound traffic"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags   = {
    Name = "ramp-up Jenkins EC2"
  }
}
