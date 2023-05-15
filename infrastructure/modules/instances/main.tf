provider "aws" {
  region = var.region
}

resource "aws_key_pair" "key_pair" {
  key_name   = "key_pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_launch_configuration" "lc" {
  name_prefix                 = var.launch_configuration_name_prefix
  image_id                    = data.aws_ami.amazon-linux.id
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.ec2_sg.id]
  key_name                    = aws_key_pair.key_pair.key_name
  user_data                   = file("${path.module}/user_data.sh") # Path: infrastructure/modules/instances/user_data.sh
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "Autoscaling Group"
  launch_configuration = aws_launch_configuration.lc.id
  min_size             = 1
  max_size             = var.desired_capacity + 1
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = var.public_subnets

  tag {
    key                 = "Name"
    value               = "asg_instance"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_alb_target_group.target_group.arn
}

# ALB Security Group (Traffic Internet -> ALB)
resource "aws_security_group" "load_balancer_sg" {
  name        = "load_balancer_security_group"
  description = "Controls access to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "foo_app_security_group"
  description = "Allow inbound SSH and HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Load Balancer
resource "aws_lb" "load_balancer" {
  name               = "foo-app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.load_balancer_sg.id]

  tags = {
    Name = "App Load Balancer"
  }
}

# Target group
resource "aws_alb_target_group" "target_group" {
  name     = "foo-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_alb_listener" "foo_alb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.target_group]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target_group.arn
  }
}
