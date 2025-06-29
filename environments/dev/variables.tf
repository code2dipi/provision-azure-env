
variable "resource_group_name" {
    description = "Resource group name"
    default = "rg-terraform-dev"
    type  =string
}
variable "location" {
    description = "Azure region for resources"
    type = string
    default = "westeurope"
}