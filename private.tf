/*
  Database Servers
*/
resource "aws_security_group" "app" {
    name = "vpc_app"
    description = "Allow incoming web connections."



    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags = {
        Name = "AppServerSG"
    }
}

resource "aws_instance" "app-1" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "${var.aws_az}"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    user_data = templatefile("${path.module}/app-userdata.tpl",{s3location=var.s3-location})
    iam_instance_profile = "${var.s3role}"
    vpc_security_group_ids = ["${aws_security_group.app.id}"]
    subnet_id = "${aws_subnet.ap-south-1a-private.id}"
    source_dest_check = false

    tags = {
        Name = "App Server 1"
    }
}
