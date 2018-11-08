provider aws {
  region = "us-east-1"
}

resource "aws_vpc" "production" {
  cidr_block = "${var.vpc_cidr_ipv4}"
  enable_dns_hostnames = true
  assign_generated_ipv6_cidr_block = true
  enable_dns_support = true


  tags {
    Name          = "${ var.environment }"
    Environment   = "${ var.environment }"
    Owner         = "${ var.owner }"
    Service       = "${ var.service }"
    Provisioner   = "${ var.provisioner }"
  }
}

resource "aws_subnet" "production" {
    vpc_id                          = "${aws_vpc.production.id}"
    cidr_block                      = "${cidrsubnet(aws_vpc.production.cidr_block, 4, 1)}"
    map_public_ip_on_launch         =  "${ var.ip_public }"

    ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.production.ipv6_cidr_block, 8, 1)}"
    assign_ipv6_address_on_creation = true
    
}

resource "aws_internet_gateway" "production" {
    vpc_id = "${aws_vpc.production.id}"
}

resource "aws_default_route_table" "production" {
    default_route_table_id = "${aws_vpc.production.default_route_table_id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.production.id}"
    }

    route {
        ipv6_cidr_block = "::/0"
        gateway_id      = "${aws_internet_gateway.production.id}"
    }
}

resource "aws_route_table_association" "production" {
    subnet_id      = "${aws_subnet.production.id}"
    route_table_id = "${aws_default_route_table.production.id}"
}

resource "aws_security_group" "production" {
    name   = "hello-world"
    vpc_id = "${aws_vpc.production.id}"
    
    ingress {
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      ipv6_cidr_blocks = ["::/0"]
    }
}
