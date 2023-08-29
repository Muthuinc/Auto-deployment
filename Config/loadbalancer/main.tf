terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# It takes the AWS cred from the Jenkins. 
# look at the top portion of jenkins file

provider "aws" {
  region = var.region
}

# Create AMI for launch template & auto-scaling
# The below AMI will get the values from the variables.tf file
resource "aws_ami_from_instance" "My_ami" {
  name               = var.template_name                           # AMI name
  source_instance_id = var.server_id                               # EC2 Instance ID from where we create the AMI
  snapshot_without_reboot = "true"
}

# ------------------------------------------------------------------------------------------------

#Creating security group for the loadbalancer alowing only port 80
resource "aws_security_group" "group2" {
  name        = "allow_port80"
  description = "Allow all inbound traffic from anywhere"
  vpc_id      = var.vpc_id                                          # VPC ID where our EC2 instance is running

  ingress {
    description      = "TLS from VPC"
    from_port        = var.security_group_port
    to_port          = var.security_group_port
    protocol         = "tcp"
    cidr_blocks      = var.access_ip
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allowall"
  }
}

# -------------------------------------------------------------------------------------------------

# Create launch template which is required for auto-scaling
resource "aws_launch_template" "My_template" {
  name = "My_template"
  description = "for auto scaling"
  image_id = aws_ami_from_instance.My_ami.id                       # This is the AMI which we create before look above
  instance_type = "t2.micro"
  #security_groups     = ["aws_security_group.group1.name"]
  #vpc_security_group_ids = ["sg-09afc32cea89cb106"]
  key_name = "Ava"
  
 user_data = base64encode(
  <<-EOF
    #!/bin/bash
    sudo systemctl restart docker
    sudo docker restart $(sudo docker ps -aq)
  EOF
)

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.group2.id]
  }
}

# -------------------------------------------------------------------------------------------

# Loadbalancer target group
resource "aws_lb_target_group" "CustomTG" {
  name     = "Mytargetgp"
  port     = var.security_group_port                     # this is the port which we access our application in our EC2 instance
  protocol = "HTTP"
  vpc_id   = var.vpc_id                                  # VPC where our Ec2 is running
  target_type = "instance"
  health_check {
    path        = "/"
    protocol    = "HTTP"
    interval    = 30
    timeout     = 5
    healthy_threshold = 3
    unhealthy_threshold = 2
    matcher     = "200"
  }
}

# Target group attachment -- This is like the second page when we create LB target group in web console
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.CustomTG.arn          # This is the ARN of our LB target group which we create
  target_id        = var.server_id                             # EC2 instance ID 
  port             = 5000                                      # Port our application is running
}

# -------------------------------------------------------------------------------------------

# Loadbalancer comes here
resource "aws_lb" "alb" {
  name               = "Mylb"
  internal           = false
  load_balancer_type = "application"
  security_groups     = [aws_security_group.group2.id]       # The security group for the loadbalancer to follow
  subnets            = var.subnet_ids                        # Subnet ID - atleast two subnets must be given
}

# This is where our loadbalncer is going to redirect the request (The target group rules)
resource "aws_lb_listener" "My-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"                                   # Our loadbalancer DNS will work under HTTP
  protocol          = "HTTP"
  default_action {
    type             = "forward"                             # Forwarding the request to the target group
    target_group_arn = aws_lb_target_group.CustomTG.arn
  }
}



