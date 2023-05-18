output "database_ip" {
  value = aws_instance.database.private_ip
}

output "key_pair_name" {
  description = "Key pair name"
  value       = aws_key_pair.key_pair.key_name
}