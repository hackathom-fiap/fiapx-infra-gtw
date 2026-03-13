# Data source para obter a VPC existente
data "aws_vpc" "existing" {
  id = var.vpc_id
}

# Data source para obter as subnets existentes (Filtrando zonas compatíveis com VPC Link)
data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c"]
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
  integration_method = "ANY"
  payload_format_version = "1.0"
}

# 4. Definição das Rotas da Aplicação

# Rota de Cadastro de Usuário
resource "aws_apigatewayv2_route" "auth_register" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST /api/auth/register"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

# Rota de Login
resource "aws_apigatewayv2_route" "auth_login" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST /api/auth/login"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

# Rota de Upload de Vídeo
resource "aws_apigatewayv2_route" "video_upload" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST /api/videos/upload"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

# Rota de Status de Vídeos
resource "aws_apigatewayv2_route" "video_status" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "GET /api/videos/status"
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}

# Rota Padrão (Fallback)
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