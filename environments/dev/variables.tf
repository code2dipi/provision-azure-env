
variable "resource_group_name" {
  description = "Resource group name"
  default     = "rg-terraform-dev"
  type        = string
}
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "westeurope"
}
variable "postgres_admin_username" {
  description = "PostgreSQL admin username"
  type        = string
}
variable "postgres_admin_password" {
  description = "PostgreSQL admin password"
  type        = string
  sensitive   = true
}