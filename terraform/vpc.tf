resource "aws_vpc" "devops-demo" {
  cidr_block = "172.16.0.0/24"
  # instance_tenancy = "dedicated"

  tags {
    Name = "devops-demo"
    Project = "devops-demo"
  }
}

resource "aws_internet_gateway" "devops-demo" {
  vpc_id = "${aws_vpc.devops-demo.id}"

  tags {
    Name = "devops-demo"
    Project = "devops-demo"
  }
}

resource "aws_subnet" "devops-demo-app-a" {
  vpc_id = "${aws_vpc.devops-demo.id}"
  cidr_block = "172.16.0.0/27"
  availability_zone = "us-east-1a"

  tags {
    Name = "devops-demo-app-a"
    Project = "devops-demo"
  }
}

resource "aws_subnet" "devops-demo-app-b" {
  vpc_id = "${aws_vpc.devops-demo.id}"
  cidr_block = "172.16.0.32/27"
  availability_zone = "us-east-1b"

  tags {
    Name = "devops-demo-app-b"
    Project = "devops-demo"
  }
}

resource "aws_subnet" "devops-demo-db-a" {
  vpc_id = "${aws_vpc.devops-demo.id}"
  cidr_block = "172.16.0.64/27"

  tags {
    Name = "devops-demo-db-a"
    Project = "devops-demo"
  }
}

resource "aws_subnet" "devops-demo-db-b" {
  vpc_id = "${aws_vpc.devops-demo.id}"
  cidr_block = "172.16.0.96/27"

  tags {
    Name = "devops-demo-db-b"
    Project = "devops-demo"
  }
}

resource "aws_security_group" "devops-demo-ssh" {
  name        = "devops-demo-ssh"
  description = "allow ssh"
  vpc_id      = "${aws_vpc.devops-demo.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "devops-demo-ssh"
    Project = "devops-demo"
  }
}

resource "aws_security_group" "devops-demo-http" {
  name        = "devops-demo-http"
  description = "allow http"
  vpc_id      = "${aws_vpc.devops-demo.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "devops-demo-http"
    Project = "devops-demo"
  }
}

resource "aws_main_route_table_association" "devops-demo" {
  vpc_id = "${aws_vpc.devops-demo.id}"
  route_table_id = "${aws_route_table.devops-demo.id}"
}

resource "aws_route_table" "devops-demo" {
  vpc_id = "${aws_vpc.devops-demo.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.devops-demo.id}"
  }

  # route {
  #   ipv6_cidr_block = "::/0"
  #   egress_only_gateway_id = "${aws_egress_only_internet_gateway.foo.id}"
  # }

  tags {
    Name = "devops-demo"
  }
}

resource "aws_security_group" "devops-demo-db" {
  name        = "devops-demo-db"
  description = "allow connect to db"
  vpc_id      = "${aws_vpc.devops-demo.id}"

  tags {
    Name = "devops-demo-db"
  }
}

resource "aws_security_group_rule" "allow-tcp" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.devops-demo-http.id}"
  security_group_id = "${aws_security_group.devops-demo-db.id}"
}

resource "aws_security_group_rule" "allow-udp" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "udp"
  source_security_group_id = "${aws_security_group.devops-demo-http.id}"
  security_group_id = "${aws_security_group.devops-demo-db.id}"
}

resource "aws_security_group_rule" "allow-icmp" {
  type            = "ingress"
  from_port       = 0
  to_port         = 8
  protocol        = "icmp"
  source_security_group_id = "${aws_security_group.devops-demo-http.id}"
  security_group_id = "${aws_security_group.devops-demo-db.id}"
}

resource "aws_security_group_rule" "allow-tcp-db-port" {
  type            = "ingress"
  from_port       = 5432
  to_port         = 5432
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.devops-demo-http.id}"
  security_group_id = "${aws_security_group.devops-demo-db.id}"
}