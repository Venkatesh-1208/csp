# ---------------------------------------------------------------------------
# Azure Authentication
# ---------------------------------------------------------------------------
variable "azure_tenant_id" {
  description = "Azure Active Directory Tenant ID"
  type        = string
  sensitive   = true
}

variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "azure_client_id" {
  description = "Service Principal Client ID (for CI authentication)"
  type        = string
  sensitive   = true
}

variable "azure_client_secret" {
  description = "Service Principal Client Secret (for CI authentication)"
  type        = string
  sensitive   = true
}

# ---------------------------------------------------------------------------
# Deployment Scope
# ---------------------------------------------------------------------------
variable "environment" {
  description = "Deployment environment (dev / staging / prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Short project name used in resource naming"
  type        = string
  default     = "csp"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "southcentralus"
}

# ---------------------------------------------------------------------------
# Feature Flags (mirrors workflow_dispatch inputs)
# ---------------------------------------------------------------------------
variable "deploy_web" {
  description = "Whether to deploy the Web Tier module"
  type        = bool
  default     = true
}

variable "deploy_data" {
  description = "Whether to deploy the Data Tier module"
  type        = bool
  default     = true
}
