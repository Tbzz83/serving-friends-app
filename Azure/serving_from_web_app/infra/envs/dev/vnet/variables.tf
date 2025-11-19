variable "bnd_subscription_id" {
  type = string
  sensitive = true
}

variable "source_address_prefix_my_pc" {
  type      = string
  sensitive = true
}

variable "smullbw_ip_1" {
  type      = string
  sensitive = true
}

variable "allowed_ips_list" {
  type = list(string)
  sensitive = true
}

