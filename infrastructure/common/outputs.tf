# Output Public DNS name for ELB
output "Public_ELB_DNS" {
  value = aws_lb.ASG_load_balancer.dns_name
}