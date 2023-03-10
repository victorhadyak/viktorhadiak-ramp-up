provider "aws" {
  region = ""  
  access_key = ""
  secret_key = ""
}

variable "ami" {
	default = "ami-0a5b5c0ea66ec560d"
}

variable "ec2_type" {
	default = "t2.micro"	
}

variable "my_jenkins_cidr_block" {
  description = "CIDR block for jenkins security group"
  default     = "185.48.129.75/32"
}

variable "a_zone" {
	default = "eu-central-1a"	
}
