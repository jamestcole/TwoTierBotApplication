# Output the Load Balancer DNS
output "load_balancer_dns" {
  description = "The DNS name of the application load balancer"
  value       = aws_lb.app-lb.dns_name
}

# Output the RDS endpoint
output "db_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.app-db.endpoint
}

# Output ECS Cluster Name
output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.app-cluster.name
}

# Output ECS Service Name
output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.app-service.name
}
