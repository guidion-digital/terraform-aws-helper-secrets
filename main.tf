resource "aws_secretsmanager_secret" "these" {
  for_each = var.secrets

  name        = each.key
  description = each.value.description

  kms_key_id                     = each.value.kms_key_id
  policy                         = each.value.policy
  recovery_window_in_days        = each.value.recovery_window_in_days
  force_overwrite_replica_secret = each.value.force_overwrite_replica_secret

  tags = var.tags
}

resource "aws_secretsmanager_secret_rotation" "these" {
  for_each = {
    for this_secret, these_settings in var.secrets : this_secret =>
    these_settings if these_settings.rotation_configuration != null
  }

  secret_id           = aws_secretsmanager_secret.these[each.key].id
  rotation_lambda_arn = var.secrets[each.key].rotation_configuration.lambda_arn

  rotation_rules {
    automatically_after_days = var.secrets[each.key].rotation_configuration.days
  }
}
