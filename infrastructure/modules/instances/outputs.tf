output "autoscaling_group_id" {
  description = "ID of the autoscaling group"
  value       = aws_autoscaling_group.asg.id
}

output "autoscaling_group_arn" {
  description = "Arn of the autoscaling group"
  value       = aws_autoscaling_group.asg.arn
}

output "key_pair_name" {
  description = "Key pair name"
  value       = aws_key_pair.key_pair.key_name
}

output "load_balancer_dns_name" {
  description = "Load balancer DNS name"
  value       = aws_lb.load_balancer.dns_name
}

output "load_balancer_zone_id" {
  description = "Load balancer zone ID"
  value       = aws_lb.load_balancer.zone_id
}
