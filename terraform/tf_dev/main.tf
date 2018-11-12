provider aws {
  region = "${ var.region }"
}

resource "aws_vpc" "develop" {
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

resource "aws_subnet" "develop" {
    vpc_id                          = "${aws_vpc.develop.id}"
    cidr_block                      = "${cidrsubnet(aws_vpc.develop.cidr_block, 4, 1)}"
    map_public_ip_on_launch         =  "${ var.ip_public }"

    ipv6_cidr_block                 = "${cidrsubnet(aws_vpc.develop.ipv6_cidr_block, 8, 1)}"
    assign_ipv6_address_on_creation = true
    
    tags {
    Name          = "${ var.environment }"
    Environment   = "${ var.environment }"
    Owner         = "${ var.owner }"
    Service       = "${ var.service }"
    Provisioner   = "${ var.provisioner }"
  }

}

resource "aws_internet_gateway" "develop" {
    vpc_id = "${aws_vpc.develop.id}"
      tags {
    Name          = "${ var.environment }"
    Environment   = "${ var.environment }"
    Owner         = "${ var.owner }"
    Service       = "${ var.service }"
    Provisioner   = "${ var.provisioner }"
  }
}

resource "aws_default_route_table" "develop" {
    default_route_table_id = "${aws_vpc.develop.default_route_table_id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.develop.id}"
    }

    route {
        ipv6_cidr_block = "::/0"
        gateway_id      = "${aws_internet_gateway.develop.id}"
    }
      tags {
    Name          = "${ var.environment }"
    Environment   = "${ var.environment }"
    Owner         = "${ var.owner }"
    Service       = "${ var.service }"
    Provisioner   = "${ var.provisioner }"
  }
}

resource "aws_route_table_association" "develop" {
    subnet_id      = "${aws_subnet.develop.id}"
    route_table_id = "${aws_default_route_table.develop.id}"
}

resource "aws_security_group" "develop" {
    name   = "hello-world-develop"
    vpc_id = "${aws_vpc.develop.id}"
    ingress {
        from_port   = 0
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port        = 0
        to_port          = 22
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
      tags {
    Name          = "${ var.environment }"
    Environment   = "${ var.environment }"
    Owner         = "${ var.owner }"
    Service       = "${ var.service }"
    Provisioner   = "${ var.provisioner }"
  }
}
