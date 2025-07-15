resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/hello_lambda"
  retention_in_days = 3
}
