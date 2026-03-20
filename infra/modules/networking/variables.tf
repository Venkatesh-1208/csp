variable "deploy" { type = bool }
variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "address_space" { type = string }
variable "subnets" {
  type = object({
    app      = string
    db       = string
    storage  = string
    keyvault = string
  })
}
variable "tags" { type = map(string) }
