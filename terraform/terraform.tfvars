aws_region   = "us-east-1"
project_name = "fiapx-api-gateway"

vpc_id     = "vpc-8ce247f1"

# ARNs do Network Load Balancer (NLB) criado pelo NGINX Ingress Controller
nlb_arn = "arn:aws:elasticloadbalancing:us-east-1:239409137076:loadbalancer/net/ab3335395b8b344e985dba2cdc56971d/e7fd5e7564f3bcea"
nlb_listener_arn = "arn:aws:elasticloadbalancing:us-east-1:239409137076:listener/net/ab3335395b8b344e985dba2cdc56971d/e7fd5e7564f3bcea/26753c4d63fd5acb"

# Security Group do Cluster EKS para o VPC Link
vpc_link_security_group_ids = ["sg-0029147ed7e3cef12"]

