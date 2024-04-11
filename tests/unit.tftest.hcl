run "secrets" {
  module {
    source = "./examples/test_app"
  }

  command = plan

  variables {
    recovery_window_in_days        = 0
    force_overwrite_replica_secret = true
    kms_key_id                     = "foobar"

    rotation_configuration = {
      lambda_arn = "arn:aws:lambda:eu-central-1:123456789012:function:you-secret-rotator"
      days       = 7
    }

    policy = {
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
    }
  }

  assert {
    condition     = length(module.secrets.arns) > 0
    error_message = "Secrets were not created"
  }
}

