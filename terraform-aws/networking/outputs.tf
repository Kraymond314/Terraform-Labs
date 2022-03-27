# --- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.labs_vpc.id
}

output "db_security_group" {
    value = [aws_security_group.labs_security["rds"].id]
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.labs_rds_subnetgroup.*.name
}

output "public_subnets" {
  value = [for subnet in aws_subnet.labs_public_subnet : subnet.id]
}

output "public_sg" {
  value = aws_security_group.labs_security["public"].id
}