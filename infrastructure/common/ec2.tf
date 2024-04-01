resource "aws_security_group" "instance_sg" {
  vpc_id      = aws_vpc.NodeJS_App_ASG_VPC.id
  name        = "NodeJS App SG"
  description = "Allows SSH, HTTP, ICMP access"

  # Allows SSH access from anywhere 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows HTTP access from anywhere 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows ICMP access from anywhere 
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows outbound Internet access from anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NodeJS_App_ASG_sg"
  }
}

# Launch configuration description
resource "aws_launch_configuration" "ASG_launch_config" {
  name            = "NodeJS_App_ASG_Launch_config"
  image_id        = var.instance_ami  #  AMI ID
  instance_type   = var.instance_type # instance type
  key_name        = var.instance_ssh_key
  security_groups = [aws_security_group.instance_sg.id]
  user_data       = file("${path.module}/../../user_data/user-data.sh")
}

# Auto Scaling Group definition
resource "aws_autoscaling_group" "NodeJS_App_ASG" {
  name                      = "NodeJS_App_ASG"
  vpc_zone_identifier       = aws_subnet.public_subnets[*].id
  launch_configuration      = aws_launch_configuration.ASG_launch_config.name
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  health_check_grace_period = 300
  health_check_type         = "EC2"
  target_group_arns         = [aws_lb_target_group.ASG_target_group.arn]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  tag {
    key                 = "Name"
    value               = "NodeJS_App_ASG_Instance" # name for EC2 instances created by ASG
    propagate_at_launch = true
  }
}

# Target group definition
resource "aws_lb_target_group" "ASG_target_group" {
  name     = "ASG-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.NodeJS_App_ASG_VPC.id

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    timeout             = 5
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

# Attach target group to your auto-scaling group
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.NodeJS_App_ASG.name
  lb_target_group_arn    = aws_lb_target_group.ASG_target_group.arn
}


# Security group for the ELB
resource "aws_security_group" "elb_sg" {
  vpc_id = aws_vpc.NodeJS_App_ASG_VPC.id

  # Allows HTTP and HTTPS traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allows outbound Internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NodeJS_App_ASG_ELBSG"
  }
}

# Elastic load balancer creation
resource "aws_lb" "ASG_load_balancer" {
  name               = "NodeJS-App-ASG-ELB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id]

  tags = {
    Name = "NodeJS_App_ASG_ELB"
  }
}

# Configure listeners for the ELB, forward traffic to target group
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.ASG_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ASG_target_group.arn
  }
}
