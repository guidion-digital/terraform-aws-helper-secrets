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
        lambda_arn          = module.secret_rotator.lambda_function_arn
        schedule_expression = "rate(1 day)"
      }

    }
  }
}

### BEGIN EXISTING RESOURCES ###
#
# These resources should already exist outside this module

module "secret_rotator" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.7.1"

  publish = true

  function_name = "rotate-secret-x"
  handler       = "debug.handler"
  runtime       = "python3.9"
  source_path   = "./rotation-lambda"
}

### END EXISTING RESOURCES ###
