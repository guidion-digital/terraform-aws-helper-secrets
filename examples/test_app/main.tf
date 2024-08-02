module "secrets" {
  source = "../../"

  secrets = {
    "test-secret" = {
      description                    = "Testing things"
      kms_key_id                     = "foobar"
      recovery_window_in_days        = 0
      force_overwrite_replica_secret = true

      policy = jsonencode({
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Effect" : "Allow",
            "Principal" : "*",
            "Action" : [
              "secretsmanager:DescribeSecret",
              "secretsmanager:PutSecretValue",
              "secretsmanager:ListSecretVersionIds"
            ],
            "Resource" : "*"
          },
          {
            "Effect" : "Allow",
            "Principal" : "*",
            "Action" : [
              "secretsmanager:GetRandomPassword",
              "secretsmanager:ListSecrets",
              "secretsmanager:BatchGetSecretValue"
            ],
            "Resource" : "*"
          }
        ]
      })

      rotation_configuration = {
        lambda_arn          = "arn:aws:lambda:eu-central-1:123456789012:function:you-secret-rotator"
        schedule_expression = "rate(1 day)"
      }

    }
  }
}
