output "frontend_url" {
  value = aws_s3_bucket_website_configuration.frontend_website.website_endpoint
}
