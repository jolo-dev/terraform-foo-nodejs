output "load_balancer_dns_name" {
  description = "Load Balancer DNS Name"
  value       = "http://${module.instances.load_balancer_dns_name}"
}
