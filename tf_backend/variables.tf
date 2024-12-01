variable "bnd_subscription_id" {
  type      = string
  sensitive = true
}

variable "tag" {
  type    = string
  default = "backend"
}
