provider "aws" {
  profile = "default"
  region = "${var.aws_region}"
}

# VPC and IG-
module "VPC" {
  source = "./Network/VPC/VPC"
}

# -Subnets
module "PublicSubnet" {
  source = "./Network/Subnet/Subnet"
  vpc_id = "${module.VPC.VPC_ID}"
  subnet_cidr = "10.0.0.0/24"
  subnet_name = "PublicSubnet"
}

module "PrivateSubnet1" {
  source = "./Network/Subnet/Subnet"
  vpc_id = "${module.VPC.VPC_ID}"
  subnet_cidr = "10.0.1.0/24"
  subnet_name = "PrivateSubnet1"
}

module "PrivateSubnet2" {
  source = "./Network/Subnet/Subnet"
  vpc_id = "${module.VPC.VPC_ID}"
  subnet_cidr = "10.0.1.128/24"
  subnet_name = "PrivateSubnet2"
}

resource "aws_eip" "NAT-EIP" {}

module "NATGateway" {
  source = "./Network/NATGateway/NATGateway"
  elasticIPID = "${aws_eip.NAT-EIP.id}"
  subnet_id = "${module.PublicSubnet.subnet_id}"
}

# --Route Tables
module "PublicRouteTable" {
  source = "./Network/RouteTable/RouteTable"
  vpc_id = "${module.VPC.VPC_ID}"
  gateway_id = "${module.VPC.IG_ID}"
  RouteTableName = "PublicRouteTable"
}

module "PrivateRouteTable" {
  source = "./Network/RouteTable/RouteTable"
  vpc_id = "${module.VPC.VPC_ID}"
  gateway_id = "${module.NATGateway.NATGateway_id}"
  RouteTableName = "PublicRouteTable"
}

module "PublicSubnetRoute" {
  source = "./Network/Route/Route"
  route_table_id = "${module.PublicRouteTable.route_table_id}"
  gateway_id = "${module.VPC.IG_ID}"
  is_to_nat = false
}

module "PrivateSubnetRoute" {
  source = "./Network/Route/Route"
  route_table_id = "${module.PrivateRouteTable.route_table_id}"
  nat_gateway_id = "${module.NATGateway.NATGateway_id}"
  is_to_nat = true
}

module "PublicRouteTableAssociation" {
  source = "./RouteTableAssociation/RouteTableAssociation"
  subnet_id = "${module.PublicSubnet.subnet_id}"
  route_table_id = "${module.PublicRouteTable.route_table_id}"
}

module "PrivateRouteTableAssociation1" {
  source = "./RouteTableAssociation/RouteTableAssociation"
  subnet_id = "${module.PrivateSubnet1.subnet_id}"
  route_table_id = "${module.PrivateRouteTable.route_table_id}"
}

module "PrivateRouteTableAssociation2" {
  source = "./RouteTableAssociation/RouteTableAssociation"
  subnet_id = "${module.PrivateSubnet2.subnet_id}"
  route_table_id = "${module.PrivateRouteTable.route_table_id}"
}

# Security Group
module "PublicEC2SecurityGroup" {
  source = "./Network/SecurityGroup/SecurityGroup"
  vpc_id = "${module.VPC.VPC_ID}"
}

module "PrivateEC2SecurityGroup" {
  source = "./Network/SecurityGroup/SecurityGroup"
  vpc_id = "${module.VPC.VPC_ID}"
}

module "RDSSecurityGroup" {
  source = "./Network/SecurityGroup/SecurityGroup"
  vpc_id = "${module.VPC.VPC_ID}"
}


# Ingress rule for public EC2 which only allows SSH from Quantiphi Eureka
module "public_ec2_sg_ingress_ssh" {
  source = "./Network/SecurityGroupRule/SecurityGroupRule"
  is_cidr_source = false
  type = "ingress"
  security_group_id = "${module.PublicEC2SecurityGroup.security_group_id}"
  cidr_blocks = ["59.152.53.168/30", "59.152.53.104/29", "59.152.53.200/29", "59.152.53.120/29"]
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
}

# Egress rule for public EC2 which only allows HTTP for package updates
module "public_ec2_sg_egress_http" {
  source = "./Network/SecurityGroupRule/SecurityGroupRule"
  is_cidr_source = true
  type = "egress"
  security_group_id = "${module.PublicEC2SecurityGroup.security_group_id}"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Egress rule for public EC2 which only allows HTTPS for package updates
module "public_ec2_sg_egress_https" {
  source = "./Network/SecurityGroupRule/SecurityGroupRule"
  is_cidr_source = true
  type = "egress"
  security_group_id = "${module.PublicEC2SecurityGroup.security_group_id}"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Ingress rule for private EC2 which only allows SSH from public ec2 instance
module "private_ec2_sg_ingress_ssh" {
  source = "./Network/SecurityGroupRule/SecurityGroupRule"
  is_cidr_source = false
  type = "ingress"
  security_group_id = "${module.PrivateEC2SecurityGroup.security_group_id}"
  source_security_group_id = "${module.PublicEC2SecurityGroup.security_group_id}"
  from_port = 22
  to_port = 22
  protocol = "tcp"
}

# Egress rule for private EC2 which only allows HTTP for package updates
module "private_ec2_sg_egress_http" {
  source = "./Network/SecurityGroupRule/SecurityGroupRule"
  is_cidr_source = true
  type = "egress"
  security_group_id = "${module.PrivateEC2SecurityGroup.security_group_id}"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Egress rule for private EC2 which only allows HTTPS for package updates
module "private_ec2_sg_egress_https" {
  source = "./Network/SecurityGroupRule/SecurityGroupRule"
  is_cidr_source   = true
  type = "egress"
  security_group_id = "${module.PrivateEC2SecurityGroup.security_group_id}"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Egress rule for private EC2 which allows MySQL connection with private RDS instance
module "private_ec2_sg_egress_rds" {
  source = "./Network/SecurityGroupRule/SecurityGroupRule"
  is_cidr_source = false
  type = "egress"
  security_group_id = "${module.PrivateEC2SecurityGroup.security_group_id}"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = "${module.RDSSecurityGroup.security_group_id}"
}

# Ingress rule for private RDS which only allows connection from private ec2 instance
module "rds_sg_ingress" {
  source = "./Network/SecurityGroupRule/SecurityGroupRule"
  is_cidr_source = false
  type = "ingress"
  security_group_id = "${module.RDSSecurityGroup.security_group_id}"
  source_security_group_id = "${module.PrivateEC2SecurityGroup.security_group_id}"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
}

# Egress rule for private RDS which only allows HTTP for package updates
module "rds_sg_egress_http" {
  source = "./Network/SecurityGroupRule/SecurityGroupRule"
  is_cidr_source = true
  type = "egress"
  security_group_id = "${module.RDSSecurityGroup.security_group_id}"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Egress rule for private RDS which only allows HTTPS for package updates
module "rds_sg_egress_2" {
  source = "./Network/SecurityGroupRule/SecurityGroupRule"
  is_cidr_source = true
  type = "egress"
  security_group_id = "${module.RDSSecurityGroup.security_group_id}"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Public EC2 instance
module "public_ec2" {
  source    = "./EC2/EC2"
  key_name  = "AssessmentKeyYR"
  vpc_security_group_ids = "${module.PublicEC2SecurityGroup.security_group_id}"
  subnet_id = "${var.PublicSubnet.id}"
}

# Private EC2 instance
module "private_ec2" {
  source    = "./EC2/EC2"
  key_name  = "AssessmentKeyYR"
  vpc_security_group_ids = "${module.PrivateEC2SecurityGroup.security_group_id}"
  subnet_id = "${var.PrivateSubnet1.id}"

  user_data = <<EOF
    #!/bin/bash
    yum update -y
    echo "starting installation" >> start-up.log
    yum install mysql-server -y
    echo "installed" >> start-up.log
    /sbin/service mysqld start
    mysqladmin -u root password 'toor'
    RDS_MYSQL_ENDPOINT="${element(split(":", aws_db_instance.yr_RDS.endpoint), 0)}";
    RDS_MYSQL_USER="Yashraj";
    RDS_MYSQL_PASS="password";
    RDS_MYSQL_BASE="yr-db";
    mysql -h $RDS_MYSQL_ENDPOINT -u $RDS_MYSQL_USER -p$RDS_MYSQL_PASS -D $RDS_MYSQL_BASE -e 'quit';
    if [[ $? -eq 0 ]]; then
      echo "MySQL connection: OK" >> conn;
      mysql -h $RDS_MYSQL_ENDPOINT -u $RDS_MYSQL_USER -p$RDS_MYSQL_PASS -D $RDS_MYSQL_BASE --execute='CREATE TABLE yrtest( id INT)';
      echo "MySQL table create" >> conn;
      mysql -h $RDS_MYSQL_ENDPOINT -u $RDS_MYSQL_USER -p$RDS_MYSQL_PASS -D $RDS_MYSQL_BASE --execute='INSERT into yrtest (id) VALUES (1)';
      echo "MySQL insert" >> conn;
      mysql -h $RDS_MYSQL_ENDPOINT -u $RDS_MYSQL_USER -p$RDS_MYSQL_PASS -D $RDS_MYSQL_BASE --execute='SELECT * from yrtest' >> conn;
      echo "MySQL select" >> conn;
    else
      echo "MySQL connection: Fail" >> conn;
    fi;
    EOF
}

# RDS
module "yr_RDS" {
  source = "./RDS/RDS"
  db_name = "yr-DB"
  db_username = "Yashraj"
  db_password = var.db_password
  vpc_sg_ids = ["${module.RDSSecurityGroup.security_group_id}"]
  subnet_group_name = "yr_subnet_group"
  subnet_ids = [module.PrivateSubnet1.subnet_id, module.PrivateSubnet2.subnet_id]
}