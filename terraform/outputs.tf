output "api_gateway_id" {
  description = "O ID do API Gateway criado."
  value       = aws_apigatewayv2_api.this.id
}

output "api_gateway_endpoint" {
  description = "A URL de invocação do API Gateway (endpoint do stage padrão)."
  value       = aws_apigatewayv2_stage.this.invoke_url
}

output "vpc_link_id" {
  description = "O ID do VPC Link criado para conectar o API Gateway à VPC."
  value       = aws_apigatewayv2_vpc_link.this.id
}