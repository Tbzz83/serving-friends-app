# Subscription ID
variable "bnd_subscription_id" {
  type      = string
  sensitive = true
}

# My pc public IP
variable "source_address_prefix_my_pc" {
  type        = string
  description = "Permitted public IP for vnet"
  sensitive   = true
}

variable "allowed_ips_list" {
  type = list(string)
  sensitive = true
}
