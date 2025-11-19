variable "my_ip_1" {
  type      = string
  sensitive = true
}

variable "ec2_network" {
  type = map(any)
}

variable "tags" {
  type = map(string)
}
