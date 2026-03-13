variable "aws_region" {
  description = "A região da AWS onde os recursos do API Gateway serão criados."
  type        = string
}

variable "project_name" {
  description = "O nome do projeto, usado para nomear os recursos (ex: fiapx-api-gateway)."
  type        = string
}

variable "vpc_id" {
  description = "O ID da VPC existente onde o EKS está sendo executado."
  type        = string
}

variable "nlb_arn" {
  description = "O ARN (Amazon Resource Name) do Network Load Balancer (NLB) do Ingress Controller do EKS."
  type        = string
}

variable "nlb_listener_arn" {
  description = "O ARN do listener do NLB para o qual o API Gateway deve encaminhar o tráfego."
  type        = string
}

variable "vpc_link_security_group_ids" {
  description = "Uma lista de IDs de Security Groups para associar ao VPC Link."
  type        = list(string)
}
