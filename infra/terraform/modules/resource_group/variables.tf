variable "deploy" {
  description = "Whether to deploy the resource group"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Tags for the resource"
  type        = map(string)
  default     = {}
}
