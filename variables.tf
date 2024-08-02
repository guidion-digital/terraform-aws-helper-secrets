variable "tags" {
  description = "Tags to add to all resources"
  type        = map(string)

  default = {}
}

variable "secrets" {
  description = "Object of secrets, mapped to their settings"

  type = map(object({
    description                    = optional(string, null)
    kms_key_id                     = optional(string, null)
    policy                         = optional(string, null)
    recovery_window_in_days        = optional(number, 7)
    force_overwrite_replica_secret = optional(bool, false)
    rotation_configuration = optional(object({
      lambda_arn          = string
      schedule_expression = string
    }), null)
  }))
}
