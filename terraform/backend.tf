terraform {
  backend "s3" {
    bucket         = "meu-eks-terraform-state"       # Substitua pelo nome do seu bucket S3
    key            = "hackathon/gtw.tfstate" # Caminho do arquivo de estado dentro do bucket
    region         = "us-east-1"                       # Região do seu bucket S3
    dynamodb_table = "meu-eks-terraform-lock-001"           # Substitua pelo nome da sua tabela do DynamoDB para lock
    encrypt        = true
  }
}