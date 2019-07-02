/*
  Web Servers
*/
resource "aws_security_group" "web" {
    name = "vpc_web"
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = ["10.0.0.0/16"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
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
        Name = "WebServerSG"
    }
}

resource "aws_instance" "web-1" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "${var.aws_az}"
    instance_type = "t2.micro"
    key_name = "${var.aws_key_name}"
    user_data = templatefile("${path.module}/web-userdata.tpl",{s3location=var.s3-location})
    iam_instance_profile = "${var.s3role}"
    vpc_security_group_ids = ["${aws_security_group.web.id}"]
    subnet_id = "${aws_subnet.ap-south-1a-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    tags = {
        Name = "Web Server 1"
    }
}

resource "aws_eip" "web-1" {
    instance = "${aws_instance.web-1.id}"
    vpc = true
}
