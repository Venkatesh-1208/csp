variable "environment" {
  type        = string
  description = "Environment name"
  default     = "{env}"
  validation {
    condition     = contains(["dev", "test", "uat", "prod"], var.environment)
    error_message = "Valid values for environment are: dev, test, uat, prod."
  }
}
