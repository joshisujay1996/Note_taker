# VPC 
resource "aws_vpc" "myVpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"

    tags = {
        Name = "myVPC"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = "${aws_vpc.myVpc.id}"
    cidr_block = "${var.public_subnet_cidr}"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
        Name = "my_public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = "${aws_vpc.myVpc.id}"
    cidr_block = "${var.private_subnet_cidr}"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
        Name = "my_private_subnet"
    }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id = "${aws_vpc.myVpc.id}"
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1c"
  tags = {
        Name = "my_private_subnet2"
    }
}


resource "aws_internet_gateway" "internet_gw" {
    vpc_id = "${aws_vpc.myVpc.id}"
    tags = {
        Name = "VPC IGW"
    }
}

# Route table inside VPC, attached to internet gateway in ordger to access internet or internet to access you
# Therefore need to attach the public subnet to this;
resource "aws_route_table" "route_tb" {
    vpc_id = "${aws_vpc.myVpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.internet_gw.id}"
    }
    tags = {
        Name = "route table"
    }
}


resource "aws_route_table_association" "psubnet_to_rb" {
    subnet_id = "${aws_subnet.public_subnet.id}"
    route_table_id = "${aws_route_table.route_tb.id}"
}

# resource "aws_route_table_association" "private_subnet_to_rb" {
#     subnet_id = "${aws_subnet.private_subnet.id}"
#     route_table_id = "${aws_route_table.route_tb.id}"
# }

# resource "aws_route_table_association" "private_subnet_to_rb2" {
#     subnet_id = "${aws_subnet.private_subnet2.id}"
#     route_table_id = "${aws_route_table.route_tb.id}"
# }

################################################################################################

# Security group
resource "aws_security_group" "web_sec" {
    name = "web security group"
    description = "Http and SSH"
    
    ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.myVpc.id}"

  tags = {
      name = "security group for webServer"
  }
  
}


# Security group for private subnet

resource "aws_security_group" "db_sec" {
    name = "sg_test_web"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 5500
    to_port = 5500
    protocol = "tcp"
    # Allowing only public subnet ips 
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }
  
  egress {
    from_port = 5500
    to_port = 5500
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  vpc_id = "${aws_vpc.myVpc.id}"

  tags = {
    Name = "DB SG"
  }
}



output "aws_myPrivateSubnet" {
  value = "${aws_subnet.private_subnet.id}"
}
