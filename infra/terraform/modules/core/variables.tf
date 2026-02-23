# ---------------------------------------------------------------------------
# Core Module - Variables
# ---------------------------------------------------------------------------
variable "project" {
  type = string
}
variable "environment" {
  type = string
}
variable "location" {
  type = string
}
variable "location_short" {
  type = string
}
variable "common_tags" {
  type = map(string)
}
