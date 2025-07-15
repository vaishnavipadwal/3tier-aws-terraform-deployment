output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.db.name
}

output "backend_sg" {
  value = aws_security_group.backend_sg.id
}
