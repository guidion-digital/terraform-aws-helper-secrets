variable "recovery_window_in_days" {}
variable "force_overwrite_replica_secret" {}
variable "rotation_configuration" {}
variable "policy" {}
variable "kms_key_id" {}

module "secrets" {
  source = "../../"

  secrets = {
    "test-secret" = {
      description                    = "Testing things"
      kms_key_id                     = var.kms_key_id
      policy                         = jsonencode(var.policy)
      recovery_window_in_days        = var.recovery_window_in_days
      force_overwrite_replica_secret = var.force_overwrite_replica_secret
      rotation_configuration         = var.rotation_configuration
    }
  }
}
