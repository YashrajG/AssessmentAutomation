resource "aws_instance" "EC2" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "${var.instance_type}"
    key_name = "${var.aws_key_name}"
    vpc_security_group_ids = ["${var.vpc_security_group_id}"]
    subnet_id = "${var.subnet_id}"
    tags {
        Name = "${var.instance_name}"
        Project = "${var.ProjectName}"
    }
}

output "ec2_public_ip" {
  value = "${aws_instance.EC2.public_ip}"
}

output "ec2_private_ip" {
  value = "${aws_instance.EC2.private_ip}"
}