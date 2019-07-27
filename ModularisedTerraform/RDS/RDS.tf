resource "aws_db_subnet_group" "SubnetGroup" {
  name = "${var.subnet_group_name}"
  subnet_ids = "${var.subnet_ids}"
  tags = {
    Name = "${var.subnet_group_name}"
    Project = "${var.ProjectName}"
  }
}

resource "aws_db_instance" "RDS" {
  allocated_storage = "${var.allocated_storage}"
  engine = "${var.engine}"
  instance_class = "${var.instance_class}"
  name = "${var.db_name}"
  username = "${var.db_username}"
  password = "${var.db_password}"
  vpc_security_group_ids = "${var.vpc_sg_ids}"
  db_subnet_group_name = "${aws_db_subnet_group.SubnetGroup.name}"
  tags = {
    Name = "${var.db_name}"
    Project = "${var.ProjectName}"
  }
}

output "rds_id" {
  description = "The ID of the rds instance"
  value       = aws_db_instance.RDS.id
}