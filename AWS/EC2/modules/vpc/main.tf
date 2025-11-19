resource "aws_vpc" "ec2_vpc" {
  #cidr_block = each.value["cidr"]
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags             = merge(var.tags, { "Name" = "${var.tags.project_name}-vpc-${var.tags.env}" })
}

resource "aws_internet_gateway" "ec2_igw" {
  vpc_id = aws_vpc.ec2_vpc.id
  tags   = merge(var.tags, { "Name" = "${var.tags.project_name}-igw-${var.tags.env}" })
}

resource "aws_subnet" "frontend_ec2_sub" {
  vpc_id            = aws_vpc.ec2_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-2a"
  tags              = merge(var.tags, { "Name" = "${var.tags.project_name}-frontend-ec2-sub-${var.tags.env}" })
}

resource "aws_subnet" "backend_ec2_sub" {
  vpc_id            = aws_vpc.ec2_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2b"
  tags              = merge(var.tags, { "Name" = "${var.tags.project_name}-backend-ec2-sub-${var.tags.env}" })
}

resource "aws_subnet" "rds_sub_1" {
  vpc_id            = aws_vpc.ec2_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2a"
  tags              = merge(var.tags, { "Name" = "${var.tags.project_name}-rds-sub-1-${var.tags.env}" })
}

resource "aws_subnet" "rds_sub_2" {
  vpc_id            = aws_vpc.ec2_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-2b"
  tags              = merge(var.tags, { "Name" = "${var.tags.project_name}-rds-sub-2-${var.tags.env}" })
}

# === Security Groups ===
# Frontend
resource "aws_security_group" "frontend_secure_grp" {
  name        = "frontend-security-group-${var.tags.env}"
  description = "Allow all inbound traffic to frontend on port 80"
  vpc_id      = aws_vpc.ec2_vpc.id
  tags        = merge(var.tags, { "Name" = "${var.tags.project_name}-frontend-secure-grp-${var.tags.env}" })
}

resource "aws_vpc_security_group_ingress_rule" "frontend_ingress_http" {
  security_group_id = aws_security_group.frontend_secure_grp.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "${var.my_ip_1}/32"
  # From and to are the range, NOT the client port
  from_port = 80
  to_port   = 80
}

resource "aws_vpc_security_group_ingress_rule" "frontend_ingress_ssh" {
  security_group_id = aws_security_group.frontend_secure_grp.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "${var.my_ip_1}/32"
  # From and to are the range, NOT the client port
  from_port = 22
  to_port   = 22
}

resource "aws_vpc_security_group_egress_rule" "frontend_egress" {
  security_group_id = aws_security_group.frontend_secure_grp.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Backend
resource "aws_security_group" "backend_secure_grp" {
  name        = "backend-security-group-${var.tags.env}"
  description = "Only allow traffic from frontend subnet"
  vpc_id      = aws_vpc.ec2_vpc.id
  tags        = merge(var.tags, { "Name" = "${var.tags.project_name}-backend-secure-grp-${var.tags.env}" })
}

resource "aws_vpc_security_group_ingress_rule" "backend_ingress_api" {
  security_group_id = aws_security_group.backend_secure_grp.id
  cidr_ipv4         = aws_subnet.frontend_ec2_sub.cidr_block # Only allow traffic from frontend. Will proxy the request using nginx
  ip_protocol       = "tcp"
  from_port         = 5000
  to_port           = 5000
}

resource "aws_vpc_security_group_ingress_rule" "backend_ingress_ssh" {
  security_group_id = aws_security_group.backend_secure_grp.id
  cidr_ipv4         = "${var.my_ip_1}/32"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

# So we can test connection from frontend -> backend using ping
resource "aws_vpc_security_group_ingress_rule" "from_frontend" {
  security_group_id = aws_security_group.backend_secure_grp.id
  cidr_ipv4         = "10.0.0.0/24"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "backend_egress" {
  security_group_id = aws_security_group.backend_secure_grp.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# DB
resource "aws_security_group" "rds_secure_grp" {
  name        = "rds-security-group-${var.tags.env}"
  description = "Only allow traffic from backend subnet"
  vpc_id      = aws_vpc.ec2_vpc.id

  tags = merge(var.tags, { "Name" = "${var.tags.project_name}-rds-secure-grp-${var.tags.env}" })
}

resource "aws_vpc_security_group_ingress_rule" "rds_ingress_personal" {
  security_group_id = aws_security_group.backend_secure_grp.id
  cidr_ipv4         = "${var.my_ip_1}/32"
  ip_protocol       = "tcp"
  from_port         = 3306
  to_port           = 3306
}

resource "aws_vpc_security_group_ingress_rule" "rds_ingress_backend" {
  security_group_id = aws_security_group.backend_secure_grp.id
  cidr_ipv4         = aws_subnet.backend_ec2_sub.cidr_block
  ip_protocol       = "tcp"
  from_port         = 3306
  to_port           = 3306
}

# === Route Table ===
resource "aws_route_table" "vpc_route_table" {
  vpc_id = aws_vpc.ec2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ec2_igw.id
  }

  tags = merge(var.tags, { "Name" = "${var.tags.project_name}-route-table-${var.tags.env}" })
}

resource "aws_route_table_association" "frontend_assoc" {
  subnet_id      = aws_subnet.frontend_ec2_sub.id
  route_table_id = aws_route_table.vpc_route_table.id
}

resource "aws_route_table_association" "backend_assoc" {
  subnet_id      = aws_subnet.backend_ec2_sub.id
  route_table_id = aws_route_table.vpc_route_table.id
}
