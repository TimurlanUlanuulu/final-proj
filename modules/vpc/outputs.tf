output "vpc_id" {
  description = "ID of the created VPC."
  value       = aws_vpc.redhat_vpc.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the created VPC."
  value       = aws_vpc.redhat_vpc.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of public subnets."
  value       = aws_subnet.redhat_public_subnets[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets."
  value       = aws_subnet.redhat_private_subnets[*].id
}

output "public_route_table_id" {
  description = "ID of the public route table."
  value       = aws_route_table.redhat_public_route_table.id
}

output "private_route_table_id" {
  description = "ID of the private route table."
  value       = aws_route_table.redhat_private_route_table.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway."
  value       = aws_internet_gateway.redhat_igw.id
}