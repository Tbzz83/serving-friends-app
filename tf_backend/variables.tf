variable "bnd_subscription_id" {
  type      = string
  sensitive = true
}

variable "tag" {
  type    = string
  default = "backend"
}

variable "allowed_ips_list" {
  type      = list(string)
  sensitive = true
}