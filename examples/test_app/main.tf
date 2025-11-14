provider "aws" {
  region = "eu-central-1"
}

module "secrets" {
  source = "../../"

  secrets = {
    "test-secret" = {
      description = "Testing things"
      # kms_key_id                     = "foobar" # Commented out for test, but this is how it's used
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
  version = "8.1.2"

  publish = true

  function_name = "rotate-secret-x"
  handler       = "debug.handler"
  runtime       = "python3.9"
  source_path   = "./rotation-lambda"
}

resource "aws_lambda_permission" "secrets_manager_rotation" {
  statement_id  = "AllowExecutionFromSecretsManager"
  action        = "lambda:InvokeFunction"
  function_name = module.secret_rotator.lambda_function_name
  principal     = "secretsmanager.amazonaws.com"
}

### END EXISTING RESOURCES ###
