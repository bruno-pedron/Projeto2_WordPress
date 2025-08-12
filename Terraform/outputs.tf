output "alb_dns_name" {
  description = "O endereco DNS do Application Load Balancer"
  value       = aws_lb.main.dns_name
}