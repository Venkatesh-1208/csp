variable "project" { type = string }
variable "environment" { type = string }
variable "location" { type = string }
variable "location_short" { type = string }
variable "common_tags" { type = map(string) }
variable "log_analytics_id" {
  description = "Resource ID of the core Log Analytics Workspace"
  type        = string
}
variable "azure_subscription_id" {
  description = "Azure Subscription ID (used to construct Log Analytics workspace ARM path)"
  type        = string
}
