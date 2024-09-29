resource "aws_lb" "alb_ws" {
  name               = "lbws"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb.id]
  subnets            = var.subnetlist
  enable_deletion_protection = false
  tags = {
    Environment = "ws"
  }
}

resource "aws_security_group" "sg_alb" {
  name        = "allow_ws"
  description = "HTTPS HTTP"
  vpc_id      = var.vpc_id
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "ws"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb_ws.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_http.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb_ws.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg_https.arn
  }
}

resource "aws_lb_target_group" "alb_tg_http" {
  name        = "http-back"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
  health_check {
    enabled = true
    path = "/"
    port = "80"
    protocol = "HTTP"
    healthy_threshold = 3
    unhealthy_threshold = 2
    interval = 90
    timeout = 20
    matcher = "200"
  }
   depends_on = [aws_lb.alb_ws]
}

resource "aws_lb_target_group" "alb_tg_https" {
  name        = "https-back"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = var.vpc_id
  health_check {
    enabled = true
    path = "/"
    port = "443"
    protocol = "HTTPS"
    healthy_threshold = 3
    unhealthy_threshold = 2
    interval = 90
    timeout = 20
    matcher = "200"
  }
   depends_on = [aws_lb.alb_ws]
}

resource "aws_alb_target_group_attachment" "ath_http" {
  count     = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.alb_tg_http.arn
  port                     = 80
  target_id              = var.instance_ids[count.index]
}

resource "aws_alb_target_group_attachment" "ath_https" {
  count     = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.alb_tg_https.arn
  port                     = 443
  target_id              = var.instance_ids[count.index]
}
