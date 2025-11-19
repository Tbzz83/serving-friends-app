variable "my_ip_1" {
  type      = string
  sensitive = true
}

variable "ec2_pub_key" {
  type      = string
  sensitive = true
}

variable "friendsapp_rds_pass" {
  type      = string
  sensitive = true
}

locals {
  ec2_network = {

    vpcs = [
      {
        cidr = "10.0.0.0/16"
        subnets = [
          {
            cidr = "10.0.0.0/24"
            nics = [
              { private_ip = "10.0.0.0" },
            ]
          },

          {
            cidr = "10.0.1.0/24"
            nics = [
              { private_ip = "10.0.0.1" },
            ]
          },

        ]
      }
    ]

  }
  ec2_vpc_cidr = "10.0.0.0/16"
  ec2_subnets  = ["10.0.0.0/24", "10.0.1.0/24"]
  ec2_nic_ips  = ["10.0.0.1", "10.0.1.1"]
  tags = {
    project_name = "friendsapp"
    env          = "dev"
  }
}
