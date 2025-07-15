resource "aws_instance" "web" {
  ami                         = "ami-09278528675a8d54e"  # Amazon Linux 2 AMI in eu-north-1
  instance_type               = "t3.micro"               # Free tier eligible and available in eu-north-1
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y httpd php mysql
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<?php phpinfo(); ?>" > /var/www/html/index.php
              EOF

  tags = {
    Name = "backend-server"
  }
}
