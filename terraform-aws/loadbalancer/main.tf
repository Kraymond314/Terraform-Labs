#---loadbalancer/main.tf---

resource "aws_lb" "labs_alb" {
    name = "labs-loadbalancer"
    subnets = var.public_subnets
    security_groups = [var.public_sg]
    idle_timeout = 400
}