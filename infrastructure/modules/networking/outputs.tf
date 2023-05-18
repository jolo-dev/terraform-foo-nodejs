output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnets" {
  description = "List of public subnets"
  value       = [for s in aws_subnet.public_subnets : s.id]
}

output "private_subnets" {
  description = "List of private subnets"
  value       = [for s in aws_subnet.private_subnets : s.id]
}

output "public_cidr_blocks" {
  description = "List of public CIDR blocks"
  value       = [for s in aws_subnet.public_subnets : s.cidr_block]
}

output "private_cidr_blocks" {
  description = "List of private CIDR blocks"
  value       = [for s in aws_subnet.private_subnets : s.cidr_block]
}

output "igw_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "natgw_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.natgw[*].id
}
