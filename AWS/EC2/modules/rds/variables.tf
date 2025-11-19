variable "tags" {
  type = map(string)
}

variable "rds_sub_1_id" {
  type = string
}

variable "rds_sub_2_id" {
  type = string
}

variable "rds_secure_grp_id" {
  type = string
}

variable "friendsapp_rds_pass" {
  type      = string
  sensitive = true
}
