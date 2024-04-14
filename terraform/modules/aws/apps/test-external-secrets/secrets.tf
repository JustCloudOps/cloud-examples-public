resource "aws_secretsmanager_secret" "secret" {
    name = "test-external-secrets"  
}

resource "aws_secretsmanager_secret" "secret2" {
    name = "test-external-secrets-2"  
}