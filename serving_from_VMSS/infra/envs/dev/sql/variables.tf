variable "subscription_id_azure_ai_dev" {
  type      = string
  sensitive = true
}

variable "bnd_subscription_id" {
  type      = string
  sensitive = true
}

variable "source_address_prefix_my_pc" {
  type      = string
  sensitive = true
}

variable "allowed_ips_list" {
  type = list(string)
  sensitive = true
}

variable "ai_dev_sql_pw" {
  type      = string
  sensitive = true
}
