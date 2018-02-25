resource "aws_cloudwatch_log_group" "devops_demo" {
  name = "devops_demo"

  # tags {
  #   Environment = "production"
  #   Application = "serviceA"
  # }
}

resource "aws_cloudwatch_log_stream" "web" {
  name           = "web"
  log_group_name = "${aws_cloudwatch_log_group.devops_demo.name}"
}