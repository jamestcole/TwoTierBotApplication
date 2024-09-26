# Output App Server Public IP
output "app_server_public_ip" {
  description = "The public IP of the app server"
  value       = aws_eip.app_eip.public_ip
}

# Output DB Server Public IP
output "db_server_public_ip" {
  description = "The public IP of the database server"
  value       = aws_eip.db_eip.public_ip
}
