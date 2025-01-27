output "vpc_id" {
  value = aws_vpc.web_vpc.id
}

output "subnet_id" {
  value = aws_subnet.web_subnet.id
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.web_igw.id
}

output "route_table_id" {
  value = aws_route_table.web_route_table.id
}
