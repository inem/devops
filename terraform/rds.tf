resource "aws_db_subnet_group" "devops-demo" {
  name       = "main"
  subnet_ids = ["${aws_subnet.devops-demo-app-a.id}", "${aws_subnet.devops-demo-app-b.id}"]

  tags {
    Name = "devops-demo"
    Project = "devops-demo"
  }
}

resource "aws_db_instance" "devops-demo" {
  allocated_storage    = 10
  # storage_type         = "gp2"
  engine               = "postgres"
  availability_zone = "us-east-1a"
  # engine_version       = "5.6.17"
  instance_class       = "db.t2.micro"
  name                 = "${var.db_name}"
  username             = "${var.db_username}"
  password             = "${var.db_password}"
  final_snapshot_identifier = "devops-demo"
  db_subnet_group_name = "${aws_db_subnet_group.devops-demo.id}"
  vpc_security_group_ids = [
    "${aws_security_group.devops-demo-db.id}"
  ]
  /* db_subnet_group_name = "${aws_db_subnet_group.devops-demo.id}" */
  # parameter_group_name = "default.mysql5.6"
}

