variable "deploy" {
  description = "Whether to deploy the VNet and subnets"
  type        = bool
  default     = true
}

variable "vnet_name" {
  description = "Name of the virtual network"
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

variable "address_space" {
  description = "Address space for the VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "snet_app_name" {
  description = "Name of the app subnet"
  type        = string
}

variable "snet_app_prefix" {
  description = "Address prefix for the app subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "snet_data_name" {
  description = "Name of the data subnet"
  type        = string
}

variable "snet_data_prefix" {
  description = "Address prefix for the data subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
