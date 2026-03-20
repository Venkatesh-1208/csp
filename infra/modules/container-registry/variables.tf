variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "sku" { type = string }
variable "geo_replication_location" {
  type    = string
  default = ""
}
variable "tags" { type = map(string) }
