variable "deploy" {
  description = "Whether to deploy the Log Analytics workspace"
  type        = bool
  default     = true
}

variable "workspace_name" {
  description = "Name of the workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku" {
  description = "SKU for the workspace"
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Retention in days"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags for the resource"
  type        = map(string)
  default     = {}
}
