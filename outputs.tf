output "secrets" {
  description = "An object map of all the secrets generated, along with their attributes"
  value       = aws_secretsmanager_secret.these
}

output "ids" {
  description = "IDs of all the secrets created"

  value = {
    for this_secret, these_attributes in aws_secretsmanager_secret.these :
    this_secret => these_attributes.id
  }
}

output "arns" {
  description = "ARNs of all the secrets created"

  value = {
    for this_secret, these_attributes in aws_secretsmanager_secret.these :
    this_secret => these_attributes.arn
  }
}
