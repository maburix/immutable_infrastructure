
data "aws_ami" "packer_image" {
  most_recent = true

  filter {
    name   = "owner-id"
    values = [ "594951516078" ]
  }

  filter {
    name    = "name"
    values  = ["hello-world*"]
  }
}

resource "aws_elb" "hello_world" {
  name = "hello-world-elb"

  listener {
    instance_port =   5000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:5000/status"
    interval            = 10
  }

  cross_zone_load_balancing = true
  idle_timeout      = 60
  subnets           = [ "${aws_subnet.production.id}" ]
  security_groups   = [ "${aws_security_group.production.id}" ]

  tags {
    Name = "hello-world"
  }
}

resource "aws_autoscaling_group" "asg_hello_world" {
  lifecycle { create_before_destroy = true }

  name                      = "asg - ${aws_launch_configuration.lc_hello_world.name}"
  max_size                  = 3
  min_size                  = 1
  wait_for_elb_capacity     = 1
  desired_capacity          = 1
  health_check_grace_period = 10
  health_check_type         = "ELB"
  launch_configuration      = "${aws_launch_configuration.lc_hello_world.id}"
  load_balancers            = ["${aws_elb.hello_world.id}"]
  vpc_zone_identifier       = ["${aws_subnet.production.id}"]

  tag {
    key = "Name"
    value = "${ format("%s", var.name)}"
    propagate_at_launch = true

  }
}

resource "aws_launch_configuration" "lc_hello_world" {
    
    lifecycle { create_before_destroy = true }

    image_id        = "${data.aws_ami.packer_image.id}"
    instance_type   = "${ var.instance_type }"
    key_name        = "${ var.key_name }"

    security_groups = ["${aws_security_group.production.id}"]

}

data "aws_route53_zone" "maburix-demo" {
  name         = "maburix.net."
  private_zone = false
}


resource "aws_route53_record" "maburix-demo" {
  zone_id = "${data.aws_route53_zone.maburix-demo.zone_id}"
  name    = "hello"
  type    = "CNAME"
  ttl     = "30"
  records = ["${aws_elb.hello_world.dns_name}"]
}
