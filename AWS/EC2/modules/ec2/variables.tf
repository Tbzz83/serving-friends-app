variable "frontend_sub_id" {
  type = string
}

variable "friendsapp_rds_pass" {
  type      = string
  sensitive = true
}

variable "rds_db_conn_map" {
  type = map(string)
}

variable "backend_sub_id" {
  type = string
}

variable "frontend_security_grp_id" {
  type = string
}

variable "backend_security_grp_id" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "ec2_pub_key" {
  type      = string
  sensitive = true
}
