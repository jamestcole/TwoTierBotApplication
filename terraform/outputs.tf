# Output App Server Public IP
output "app_server_public_ip" {
  description = "The public IP of the app server"
  value       = aws_instance.app_server.public_ip
}

# Output DB Server Public IP
output "db_server_public_ip" {
  description = "The public IP of the database server"
  value       = aws_instance.db_server.public_ip
}
