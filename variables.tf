variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the Spinnaker resources."
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of S3 state store, this will be prepended by 'spinnaker-state-'."
  default     = "synapsestudios-com"
}

variable "create_auth_user" {
  type        = bool
  description = "If true, a Spinnker User will be created"
  default     = false
}

variable "spinnaker-managed-arns" {
  type        = list(string)
  description = "List of managed accounts (ARNs)"
}
