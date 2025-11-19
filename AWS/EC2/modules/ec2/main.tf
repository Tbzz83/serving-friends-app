# === VM IMAGE ===
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key"
  public_key = var.ec2_pub_key
}

# Backend EC2
resource "aws_instance" "backend_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.ec2_key.key_name
  associate_public_ip_address = true
  subnet_id                   = var.backend_sub_id
  vpc_security_group_ids      = [var.backend_security_grp_id]
  user_data                   = <<-EOF
#!/bin/bash
mkdir -p /home/ubuntu/friends-app-backend
echo "sql_host_db=${var.rds_db_conn_map["address"]}/${var.rds_db_conn_map["db_name"]}?ssl_check_hostname=false" >> /home/ubuntu/friends-app-backend/.env
echo "sql_pw=${var.friendsapp_rds_pass}" >> /home/ubuntu/friends-app-backend/.env
echo "sql_user=mysqladmin" >> /home/ubuntu/friends-app-backend/.env
EOF
  tags                        = merge(var.tags, { "Name" = "${var.tags.project_name}-backend-ec2-${var.tags.env}" })
}

# Frontend EC2
resource "aws_instance" "frontend_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = var.frontend_sub_id
  vpc_security_group_ids      = [var.frontend_security_grp_id]
  key_name                    = aws_key_pair.ec2_key.key_name
  user_data                   = <<-EOF
#!/bin/bash
mkdir -p /home/ubuntu/friends-app-frontend
echo "VITE_REACT_APP_API_BASE_URL=${aws_instance.backend_ec2.private_ip}:5000/api" >> /home/ubuntu/friends-app-frontend/.env
EOF
  tags                        = merge(var.tags, { "Name" = "${var.tags.project_name}-frontend-ec2-${var.tags.env}" })
}
