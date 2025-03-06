variable "bnd_subscription_id" {
  type      = string
  sensitive = true
}

variable "tag" {
  type    = string
  default = "backend"
}

variable "source_address_prefix_my_pc" {
  type = string
  sensitive = true
}