provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}



#DNS ZONE AND RECORDS
resource "aws_route53_zone" "Notejammain" {
  name = "${var.DnsZoneName}"
  comment = "Managed by terraform"
  tags {
    Name        = "${var.environment}-${var.workload_variable}_dnszonename"
    Description = "${var.environment}-${var.workload_variable}_dnszonename"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
      live        = "${var.live}"
  }
}


resource "aws_route53_record" "notejam_applanding" {
  //zone_id = "${aws_route53_zone.Notejammain.id}"
  zone_id = "${aws_route53_zone.Notejammain.zone_id}"
  name    = "applanding"
  type    = "A"

  alias {
    name                   = "${aws_lb.NotejamFronteEndALB.dns_name}"
    zone_id                = "${aws_lb.NotejamFronteEndALB.zone_id}"
    evaluate_target_health = true
  }
}


# Networking

resource "aws_vpc" "main_vpc_notejam" {
    cidr_block = "${var.vpc-fullcidr}"
   #### this 2 true values are for use the internal vpc dns resolution
    enable_dns_support = true
    enable_dns_hostnames = true

   tags {
    Name        = "${var.environment}-${var.workload_variable}-vpc4Notejam"
    Description = "${var.environment}-${var.workload_variable}-vpc4Notejam"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
}

#dns/dhcp

resource "aws_vpc_dhcp_options" "Notejamdhcp" {
    domain_name = "${var.DnsZoneName}"
    domain_name_servers = ["AmazonProvidedDNS"]
    tags {
    Name        = "${var.environment}-${var.workload_variable}_dhcpoptions"
    Description = "${var.environment}-${var.workload_variable}_dhcpoptions"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
      live        = "${var.live}"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
    vpc_id = "${aws_vpc.main_vpc_notejam.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.Notejamdhcp.id}"
}

#subnets
resource "aws_subnet" "PublicAZA" {
  vpc_id = "${aws_vpc.main_vpc_notejam.id}"
  cidr_block = "${var.Subnet-Public-AzA-CIDR}"
  tags {
    Name        = "${var.environment}-${var.workload_variable}_PublicAZA#1"
    Description = "${var.environment}-${var.workload_variable}_PublicAZA#1"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
 availability_zone = "${data.aws_availability_zones.available.names[0]}"
}
resource "aws_route_table_association" "PublicAZA" {
    subnet_id = "${aws_subnet.PublicAZA.id}"
    route_table_id = "${aws_route_table.public.id}"
}
resource "aws_subnet" "PrivateAZA" {
  vpc_id = "${aws_vpc.main_vpc_notejam.id}"
  cidr_block = "${var.Subnet-Private-AzA-CIDR}"
  tags {
    Name        = "${var.environment}-${var.workload_variable}_PrivateAZA#2"
    Description = "${var.environment}-${var.workload_variable}_PrivateAZA#2"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}
resource "aws_route_table_association" "PrivateAZA" {
    subnet_id = "${aws_subnet.PrivateAZA.id}"
    route_table_id = "${aws_route_table.privateA.id}"
}


resource "aws_subnet" "PrivateAZA_2" {
  vpc_id = "${aws_vpc.main_vpc_notejam.id}"
  cidr_block = "${var.Subnet-Private-AzA_2-CIDR}"
  tags {
    Name        = "${var.environment}-${var.workload_variable}_PrivateAZA#2_2"
    Description = "${var.environment}-${var.workload_variable}_PrivateAZA#2_2"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}
resource "aws_route_table_association" "PrivateAZA_2" {
    subnet_id = "${aws_subnet.PrivateAZA_2.id}"
    route_table_id = "${aws_route_table.privateA.id}"
}


resource "aws_subnet" "PublicAZB" {
  vpc_id = "${aws_vpc.main_vpc_notejam.id}"
  cidr_block = "${var.Subnet-Public-AzB-CIDR}"
  tags {
    Name        = "${var.environment}-${var.workload_variable}_PublicAZB#2"
    Description = "${var.environment}-${var.workload_variable}_PublicAZB#2"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
 availability_zone = "${data.aws_availability_zones.available.names[1]}"
}
resource "aws_route_table_association" "PublicAZB" {
    subnet_id = "${aws_subnet.PublicAZB.id}"
    route_table_id = "${aws_route_table.public.id}"
}
resource "aws_subnet" "PrivateAZB" {
  vpc_id = "${aws_vpc.main_vpc_notejam.id}"
  cidr_block = "${var.Subnet-Private-AzB-CIDR}"
  tags {
    Name        = "${var.environment}-${var.workload_variable}_PrivateAZB#1"
    Description = "${var.environment}-${var.workload_variable}_PrivateAZB#1"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}
resource "aws_route_table_association" "PrivateAZB" {
    subnet_id = "${aws_subnet.PrivateAZB.id}"
    route_table_id = "${aws_route_table.privateB.id}"
}

resource "aws_subnet" "PrivateAZB_2" {
  vpc_id = "${aws_vpc.main_vpc_notejam.id}"
  cidr_block = "${var.Subnet-Private-AzB_2-CIDR}"
  tags {
    Name        = "${var.environment}-${var.workload_variable}_PrivateAZB#2_2"
    Description = "${var.environment}-${var.workload_variable}_PrivateAZB#2_2"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}
resource "aws_route_table_association" "PrivateAZB_2" {
    subnet_id = "${aws_subnet.PrivateAZB_2.id}"
    route_table_id = "${aws_route_table.privateB.id}"
}

#routing
# Declare the data source
data "aws_availability_zones" "available" {}

/* EXTERNAL NETWORK , IG, ROUTE TABLE */
resource "aws_internet_gateway" "gw" {
   vpc_id = "${aws_vpc.main_vpc_notejam.id}"
    tags {
    Name        = "${var.environment}-${var.workload_variable}_iGW"
    Description = "${var.environment}-${var.workload_variable}_iGW"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
      live      = "${var.live}"
  }
}
resource "aws_network_acl" "all" {
   vpc_id = "${aws_vpc.main_vpc_notejam.id}"
    egress {
        protocol = "-1"
        rule_no = 2
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    tags {
        Name = "acl rule 100"
    }
}
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main_vpc_notejam.id}"
  tags {
      Name = "Public"
  }
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}

resource "aws_route_table" "privateA" {
  vpc_id = "${aws_vpc.main_vpc_notejam.id}"
  tags {
      Name = "PrivateA"
  }
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.PublicAZA.id}"
  }
}
resource "aws_eip" "forNatA" {
    vpc      = true
  tags {
    Name        = "${var.environment}-${var.workload_variable}_eipnatA"
    Description = "${var.environment}-${var.workload_variable}_eipnatA"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
}
resource "aws_nat_gateway" "PublicAZA" {
    allocation_id = "${aws_eip.forNatA.id}"
    subnet_id = "${aws_subnet.PublicAZA.id}"
    depends_on = ["aws_internet_gateway.gw"]
  tags {
    Name        = "${var.environment}-${var.workload_variable}_natgatewayA"
    Description = "${var.environment}-${var.workload_variable}_natgatewayA"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
}

resource "aws_route_table" "privateB" {
  vpc_id = "${aws_vpc.main_vpc_notejam.id}"
  tags {
      Name = "PrivateB"
  }
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.PublicAZB.id}"
  }
}
resource "aws_eip" "forNatB" {
    vpc      = true
  tags {
    Name        = "${var.environment}-${var.workload_variable}_eipnatB"
    Description = "${var.environment}-${var.workload_variable}_eipnatB"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
}
resource "aws_nat_gateway" "PublicAZB" {
    allocation_id = "${aws_eip.forNatB.id}"
    subnet_id = "${aws_subnet.PublicAZB.id}"
    depends_on = ["aws_internet_gateway.gw"]
   tags {
    Name        = "${var.environment}-${var.workload_variable}_natgatewayB"
    Description = "${var.environment}-${var.workload_variable}_natgatewayB"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
}

#SGs
resource "aws_security_group" "bastion" {
  name = "bastion"
  tags {
    Name        = "${var.environment}-${var.workload_variable}_bastion_SG"
    Description = "${var.environment}-${var.workload_variable}_bastion_SG"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
  description = "ONLY HTTP and SSH CONNECTION INBOUD"
  vpc_id = "${aws_vpc.main_vpc_notejam.id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["1.2.3.4/32"]
    //Note: only from my public ip
}

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "FrontEnd" {
  name = "FrontEnd"
  tags {
    Name        = "${var.environment}-${var.workload_variable}_FrontEnd_SG"
    Description = "${var.environment}-${var.workload_variable}_FrontEnd_SG"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
  description = "ONLY HTTP and HTTPS CONNECTION INBOUND, SSH from Bastion only"
  vpc_id = "${aws_vpc.main_vpc_notejam.id}"

  ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["1.2.3.4/32"]
  }
  ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        cidr_blocks = ["1.2.3.4/32"]
  }
   ingress {
      from_port = "22"
      to_port = "22"
      protocol = "TCP"
      security_groups = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "BackEnd" {
  name = "BackEnd"
  tags {
    Name        = "${var.environment}-${var.workload_variable}_BackEnd_SG"
    Description = "${var.environment}-${var.workload_variable}_BackEnd_SG"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
  description = "ONLY HTTP and HTTPS from FrontEnd and SSH CONNECTION INBOUND from bastion only"
  vpc_id = "${aws_vpc.main_vpc_notejam.id}"

  ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        security_groups = ["${aws_security_group.FrontEnd.id}"]
  }
  ingress {
        from_port = 443
        to_port = 443
        protocol = "TCP"
        security_groups = ["${aws_security_group.FrontEnd.id}"]
  }
   ingress {
      from_port = "22"
      to_port = "22"
      protocol = "TCP"
      security_groups = ["${aws_security_group.bastion.id}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#FronteEnd ALB

resource "aws_lb" "NotejamFronteEndALB" {
  name               = "NotejamFronteEndALB-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups = ["${aws_security_group.FrontEnd.id}"]
  subnets = ["${aws_subnet.PublicAZA.id}", "${aws_subnet.PublicAZB.id}" ]

  //set to false as this is demo
  enable_deletion_protection = false

/*
  access_logs {
    bucket        = "tf-notejamcloudtrailbucket"
    bucket_prefix = "notejamlog"
    enabled = true
  }
 */

   tags {
    Name        = "${var.environment}-${var.workload_variable}_FrontEnd_ALB"
    Description = "${var.environment}-${var.workload_variable}_FrontEnd_ALB"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
}

resource "aws_lb_listener" "NotejamFronteEndALB" {
  load_balancer_arn = "${aws_lb.NotejamFronteEndALB.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Redirect action

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = "${aws_lb_listener.NotejamFronteEndALB.arn}"

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    http_header {
      http_header_name = "X-Forwarded-For"
      values           = ["192.168.1.*"]
    }
  }
}

resource "aws_lb_target_group" "NotejamFronteEndALB-tg" {
  name     = "tf-NotejamFronteEndALB-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main_vpc_notejam.id}"
}

/*
resource "aws_lb_target_group_attachment" "NotejamFronteEndALB-tg-attach" {
  target_group_arn = "${aws_lb_target_group.NotejamFronteEndALB-tg.arn}"
  target_id        = "${aws_instance.Notejamapp.id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "NotejamFronteEndALB-tg-attachB" {
  target_group_arn = "${aws_lb_target_group.NotejamFronteEndALB-tg.arn}"
  target_id        = "${aws_instance.NotejamappB.id}"
  port             = 80
}
*/

#ASG Launch Template
resource "aws_launch_template" "Notejam" {
  name_prefix   = "Notejam"
  image_id      = "${lookup(var.AmiLinux, var.region)}"
  instance_type = "t2.micro"
  iam_instance_profile {
    name = "Notejam_app_instance_profile"
  }
   monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
  }
}

resource "aws_autoscaling_group" "NotejamASG" {
  availability_zones = ["eu-west-2a", "eu-west-2b"]
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1

  launch_template {
    id      = "${aws_launch_template.Notejam.id}"
    version = "$Latest"
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment_Notejam" {
  autoscaling_group_name = "${aws_autoscaling_group.NotejamASG.id}"
  //alb_target_group_arn   = "${aws_alb_target_group.NotejamFronteEndALB-tg.arn}"
  alb_target_group_arn = "${aws_lb_target_group.NotejamFronteEndALB-tg.arn}"
}


#--------------------------------------INTERNAL LOAD BALANCER

resource "aws_lb" "NotejamBackEndALB" {
  name               = "NotejamBackEndALB-lb-tf"
  internal           = true
  load_balancer_type = "application"
  security_groups = ["${aws_security_group.BackEnd.id}"]
  subnets = ["${aws_subnet.PublicAZA.id}", "${aws_subnet.PublicAZB.id}" ]

  //set to false as this is demo
  enable_deletion_protection = false

/*
  access_logs {
    bucket        = "tf-notejamcloudtrailbucket"
    bucket_prefix = "notejamlog"
    enabled = true
  }
 */

  tags {
    Name        = "${var.environment}-${var.workload_variable}_BackEnd_ALB"
    Description = "${var.environment}-${var.workload_variable}_BackEnd_ALB"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
}

resource "aws_lb_listener" "NotejamBackEndALB" {
  load_balancer_arn = "${aws_lb.NotejamBackEndALB.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Redirect action

resource "aws_lb_listener_rule" "redirect_http_to_https_Bizlogic" {
  listener_arn = "${aws_lb_listener.NotejamBackEndALB.arn}"

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    http_header {
      http_header_name = "X-Forwarded-For"
      values           = ["192.168.1.*"]
    }
  }
}

resource "aws_lb_target_group" "NotejamBackEndALB-tg" {
  name     = "tf-NotejamBackEndALB-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.main_vpc_notejam.id}"
}

#ASG Launch Template Biz Logic
resource "aws_launch_template" "NotejamBizlogic" {
  name_prefix   = "NotejamBizLogic"
  image_id      = "${lookup(var.AmiLinux, var.region)}"
  instance_type = "t2.micro"
iam_instance_profile {
    name = "Notejam_app_instance_profile"
  }
   monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
  }

}


resource "aws_autoscaling_group" "NotejamASG_BizLogic" {
  #availability_zones = ["eu-west-2a"]
  availability_zones = ["eu-west-2a", "eu-west-2b"]
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1

  launch_template {
    id      = "${aws_launch_template.NotejamBizlogic.id}"
    version = "$Latest"
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment_Notejam_BizLogic" {
  autoscaling_group_name = "${aws_autoscaling_group.NotejamASG_BizLogic.id}"
  //alb_target_group_arn   = "${aws_alb_target_group.NotejamBackEndALB-tg.arn}"
  alb_target_group_arn = "${aws_lb_target_group.NotejamBackEndALB-tg.arn}"
}


#instance profile

resource "aws_iam_instance_profile" "Notejam_app_instance_profile" {
  name  = "Notejam_app_instance_profile"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role" "role" {
  name = "Notejam_app_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

#ec2s

/* Note App EC2s now created by ASG Launch template (except bastions created as single instances, primary and backup as no need to scale bastion)
*/


resource "aws_instance" "Notejambastion" {
  ami           = "${lookup(var.AmiLinux, var.region)}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.PublicAZA.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  key_name = "${var.key_name}"
  //private_ip = "${var.private_ip1}"
  monitoring = "true"
  tags {
    Name        = "${var.environment}-${var.workload_variable}_bastion"
    Description = "${var.environment}-${var.workload_variable}_bastion"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
}

resource "aws_instance" "NotejambastionB"  {
  ami           = "${lookup(var.AmiLinux, var.region)}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.PublicAZB.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  key_name = "${var.key_name}"
  //private_ip = "${var.private_ip1_B}"
  monitoring = "true"
  tags {
    Name        = "${var.environment}-${var.workload_variable}_bastion_B"
    Description = "${var.environment}-${var.workload_variable}_bastion_B"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
}



#Database Layer rds

resource "aws_db_subnet_group" "main_db_subnet_group" {
  name        = "${var.environment}-${var.workload_variable}"
  description = "${var.environment} environment subnet group for ${var.workload_variable}"
  subnet_ids  = [ "${aws_subnet.PrivateAZA.id}", "${aws_subnet.PrivateAZB.id}" ]

  tags {
    Name        = "${var.environment}-rds-${var.workload_variable}-subnet-group"
    Description = "${var.environment}-rds-${var.workload_variable}-subnet-group"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
}

resource "aws_security_group" "default" {
  name        = "${var.environment}-rds-${var.workload_variable}-security-group"
  description = "Allow ${var.rds_engine_type} inbound traffic"
  vpc_id      = "${aws_vpc.main_vpc_notejam.id}"

  ingress {
    from_port   = "${var.database_port}"
    to_port     = "${var.database_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.Subnet-Private-AzA_2-CIDR}", "${var.Subnet-Private-AzB_2-CIDR}"]
  }

  tags {
    Name        = "${var.environment}-rds-${var.workload_variable}-security-group"
    Description = "${var.environment}-rds-${var.workload_variable}-security-group"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
}

resource "aws_db_parameter_group" "default" {
  name        = "${var.environment}-${var.workload_variable}-parameter-group"
  family      = "${var.db_parameter_group}"
  description = "RDS default parameter group"

  tags {
    Name        = "${var.environment}-rds-${var.workload_variable}-parameter-group"
    Description = "${var.environment}-rds-${var.workload_variable}-parameter-group"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
}

resource "aws_db_instance" "main_rds_instance" {
  identifier                = "${var.environment}-${var.workload_variable}"
  allocated_storage         = "${var.rds_allocated_storage}"
  storage_type              = "${var.rds_storage_type}"
  engine                    = "${var.rds_engine_type}"
  engine_version            = "${var.rds_engine_version}"
  instance_class            = "${var.rds_instance_class}"
  name                      = "${var.database_name}"
  username                  = "${var.database_user}"
  password                  = "${var.database_password}"
  port                      = "${var.database_port}"
  vpc_security_group_ids    = ["${aws_security_group.default.id}"]
  db_subnet_group_name      = "${aws_db_subnet_group.main_db_subnet_group.name}"
  parameter_group_name      = "${aws_db_parameter_group.default.name}"
  final_snapshot_identifier = "${var.environment}-${var.workload_variable}-final-snapshot"
  skip_final_snapshot       = "${var.skip_final_snapshot}"
  multi_az                  = "${var.rds_is_multi_az}"
  backup_retention_period = "${var.rds_bkup_retention_period}"

  lifecycle {
    ignore_changes = ["instance_class", "engine_version"]
  }

  tags {
    Name        = "${var.environment}-${var.workload_variable}_rds_instance"
    Description = "${var.environment}-${var.workload_variable}_rds_instance"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
}


#S3 Layer

resource "aws_s3_bucket" "notejamcloudtrailbucket" {
  bucket        = "tf-notejamcloudtrailbucket"
  force_destroy = true
  acl    = "private"
  versioning {
    enabled = true
  }

  replication_configuration {
    role = "${aws_iam_role.replication.arn}"

    rules {
      id     = "Notejambar"
      prefix = "Notejam"
      status = "Enabled"

      destination {
        bucket        = "${aws_s3_bucket.notejamreplicationdestination.arn}"
        storage_class = "STANDARD"
      }
    }
  }

  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"

    tags = {
      "rule"      = "log"
      "autoclean" = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

  tags {
    Name        = "${var.environment}-${var.workload_variable}_cloudtrailbucket"
    Description = "${var.environment}-${var.workload_variable}_cloudtrailbucket"
    project     = "${var.project}"
    environment = "${var.environment}"
    owner       = "${var.owner}"
    email       = "${var.email}"
    costcentre  = "${var.costcentre}"
    live        = "${var.live}"
  }
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::tf-notejamcloudtrailbucket"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::tf-notejamcloudtrailbucket/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

# Cross Region Replication - S3 Buckets

provider "aws" {
  alias  = "central"
  region = "eu-central-1"
}

resource "aws_iam_role" "replication" {
  name = "tf-iam-role-replication-12345"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "replication" {
  name = "tf-iam-role-policy-replication-12345"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.notejamcloudtrailbucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.notejamcloudtrailbucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.notejamreplicationdestination.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = "${aws_iam_role.replication.name}"
  policy_arn = "${aws_iam_policy.replication.arn}"
}

resource "aws_s3_bucket" "notejamreplicationdestination" {
  bucket = "tf-test-bucket-notejamreplicationdestination-12345"
  // for demo only the region set to eu-west-2 but should have been eu-central-1
  region = "eu-west-2"

  versioning {
    enabled = true
  }
}

#S3 Endpoint

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.main_vpc_notejam.id}"
  service_name = "com.amazonaws.eu-west-2.s3"

  tags = {
    Environment = "Notejam prod"
  }
}


#Cloudwatch

resource "aws_cloudwatch_dashboard" "Notejam_main" {
  dashboard_name = "Notejam-dashboard"

  dashboard_body = <<EOF
 {
   "widgets": [
       {
          "type":"metric",
          "x":0,
          "y":0,
          "width":12,
          "height":6,
          "properties":{
             "metrics":[
                [
                   "AWS/EC2",
                   "CPUUtilization",
                   "InstanceId",
                   "i-012345"
                ]
             ],
             "period":300,
             "stat":"Average",
             "region":"us-east-1",
             "title":"EC2 Instance CPU"
          }
       },
       {
          "type":"text",
          "x":0,
          "y":7,
          "width":3,
          "height":3,
          "properties":{
             "markdown":"Hello world"
          }
       }
   ]
 }
 EOF
}

#GuardDuty

resource "aws_guardduty_detector" "NotejamDetector" {
  enable = true
}
