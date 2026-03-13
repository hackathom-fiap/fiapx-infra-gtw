# Data source para obter a VPC existente
data "aws_vpc" "existing" {
  id = var.vpc_id
}

# Data source para obter as subnets existentes
data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

# 1. Criação do VPC Link para conectar o API Gateway à VPC do EKS
resource "aws_apigatewayv2_vpc_link" "this" {
  name        = "${var.project_name}-vpc-link"
  subnet_ids  = data.aws_subnets.existing.ids
  security_group_ids = var.vpc_link_security_group_ids
}

# 2. Criação do API Gateway (HTTP API)
resource "aws_apigatewayv2_api" "this" {
  name          = var.project_name
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

# 3. Criação da Integração entre o API Gateway e o NLB via VPC Link
resource "aws_apigatewayv2_integration" "this" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "HTTP_PROXY"
  integration_uri  = var.nlb_listener_arn
  connection_type  = "VPC_LINK"
  connection_id    = aws_apigatewayv2_vpc_link.this.id
}

# 4. Definição das Rotas da Aplicação
resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

# 5. Criação do Stage para deploy automático
resource "aws_apigatewayv2_stage" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  name        = "$default"
  auto_deploy = true
}