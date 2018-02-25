resource "aws_instance" "devops-demo-web" {
  ami           = "ami-66506c1c"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.devops-demo-app-a.id}"
  associate_public_ip_address = true
  key_name = "${aws_key_pair.kirillm.id}"
  iam_instance_profile = "${aws_iam_instance_profile.webserver.name}"
  vpc_security_group_ids = [
    "${aws_security_group.devops-demo-ssh.id}",
    "${aws_security_group.devops-demo-http.id}"
  ]

  tags {
    Name = "devops-demo-web-a"
    Project = "devops-demo"
  }
}

resource "aws_lb" "devops-demo" {
  name               = "devops-demo"
  internal        = false

  security_groups = ["${aws_security_group.devops-demo-http.id}"]
  subnets = ["${aws_subnet.devops-demo-app-a.id}", "${aws_subnet.devops-demo-app-b.id}"]
  tags {
    Name = "devops-demo"
    Project = "devops-demo"
  }
}

resource "aws_lb_target_group" "devops-demo" {
  name     = "devops-demo"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.devops-demo.id}"
}

resource "aws_lb_target_group_attachment" "devops-demo" {
  target_group_arn = "${aws_lb_target_group.devops-demo.arn}"
  target_id        = "${aws_instance.devops-demo-web.id}"
  port             = 80
}

resource "aws_lb_listener" "devops-demo" {
  load_balancer_arn = "${aws_lb.devops-demo.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.devops-demo.arn}"
    type             = "forward"
  }
}