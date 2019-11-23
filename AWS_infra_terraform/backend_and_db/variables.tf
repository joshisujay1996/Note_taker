variable "aws_region" {
  description = "Region for the VPC"
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.0.2.0/24"
}

variable "my_ami" {
  description = "The ami created using packer (Amazon ami with nodeJS)"
  default = "ami-0d246151e78ae04d8"
}

variable "my_key" {
  description = "The key file for ec2"
  default = "KeyPair"
  
}

