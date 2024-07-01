# VPC
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc-cidr
    enable_dns_support = true
 # Amazon의 DNS 서버가 VPC 내부에서 DNS 쿼리를 해석할 수 있도록 함
    enable_dns_hostnames = true  
# VPC에서 인스턴스에 대해 DNS 호스트 이름을 할당할 수 있는지 여부를 결정
    tags = {
        Name = var.vpc-name
    }  
}


# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id   # igw를 해당 vpc에 attatch 
  tags = {
    Name = var.igw-name
  }
}


# NATGW
resource "aws_eip" "eip1" {
  domain = "vpc"   # 해당 EIP가 VPC내에서만 사용 가능하도록 설정
}

resource "aws_eip" "eip2" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat-gw1" {
  allocation_id     = aws_eip.eip1.id             # EIP 할당
  connectivity_type = "public"                    # NATGW에 대한 연결 유형
  subnet_id         = aws_subnet.pub-sub1.id      # NATGW를 생성할 서브넷 

  tags = {
    Name = var.nat-gw1-name
  }

depends_on = [aws_internet_gateway.igw] 
# 리소스 간 생성 순서 보장(IGW 생성 후 NATGW 생성되게)
}

resource "aws_nat_gateway" "nat-gw2" {
  allocation_id     = aws_eip.eip2.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.pub-sub2.id

  tags = {
    Name = var.nat-gw2-name
  }

  depends_on = [aws_internet_gateway.igw]
}


# Subnet, RT

## Public Subnet, Public Routing Table
resource "aws_subnet" "pub-sub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub-sub1-cidr
  availability_zone       = var.az-a
  map_public_ip_on_launch = true  # 퍼블릭 IP 주소를 자동으로 할당

  tags = {
    Name = var.pub-sub1-name
  }
}

resource "aws_subnet" "pub-sub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub-sub2-cidr
  availability_zone       = var.az-c
  map_public_ip_on_launch = true

  tags = {
    Name = var.pub-sub2-name
  }
}

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id  # IGW로 향하게 설정해 인터넷 연결
  }

  tags = {
    Name = var.pub-rt-name
  }
}

resource "aws_route_table_association" "pub-rt-asso1" {
## public subnet들을 public rt에 연결
  subnet_id      = aws_subnet.pub-sub1.id
  route_table_id = aws_route_table.pub-rt.id
}

resource "aws_route_table_association" "pub-rt-asso2" {
  subnet_id      = aws_subnet.pub-sub2.id
  route_table_id = aws_route_table.pub-rt.id
}

## Private Subnet, Private Routing Table
resource "aws_subnet" "web-sub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.web-sub1-cidr
  availability_zone       = var.az-a
  map_public_ip_on_launch = false

  tags = {
    Name = var.web-sub1-name
  }
}

resource "aws_subnet" "web-sub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.web-sub2-cidr
  availability_zone       = var.az-c
  map_public_ip_on_launch = false

  tags = {
    Name = var.web-sub2-name
  }
}

resource "aws_subnet" "was-sub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.was-sub1-cidr
  availability_zone       = var.az-a
  map_public_ip_on_launch = false

  tags = {
    Name = var.was-sub1-name
  }
}

resource "aws_subnet" "was-sub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.was-sub2-cidr
  availability_zone       = var.az-c
  map_public_ip_on_launch = false

  tags = {
    Name = var.was-sub2-name
  }
}

resource "aws_subnet" "db-sub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db-sub1-cidr
  availability_zone       = var.az-a
  map_public_ip_on_launch = false

  tags = {
    Name = var.db-sub1-name
  }
}

resource "aws_subnet" "db-sub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.db-sub2-cidr
  availability_zone       = var.az-c
  map_public_ip_on_launch = false

  tags = {
    Name = var.db-sub2-name
  }
}

resource "aws_route_table" "pri-rt1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw1.id
  }

  tags = {
    Name = var.pri-rt1-name
  }
}

resource "aws_route_table" "pri-rt2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw2.id
  }

  tags = {
    Name = var.pri-rt2-name
  }
}

resource "aws_route_table_association" "pri-rt-asso1" {  # WEB
  subnet_id      = aws_subnet.web-sub1.id
  route_table_id = aws_route_table.pri-rt1.id
}

resource "aws_route_table_association" "pri-rt-asso2" {
  subnet_id      = aws_subnet.web-sub2.id
  route_table_id = aws_route_table.pri-rt2.id
}

resource "aws_route_table_association" "pri-rt-asso3" {  # WAS
  subnet_id      = aws_subnet.was-sub1.id
  route_table_id = aws_route_table.pri-rt1.id
}

resource "aws_route_table_association" "pri-rt-asso4" {
  subnet_id      = aws_subnet.was-sub2.id
  route_table_id = aws_route_table.pri-rt2.id
}


# ALB, ALB SG
## ALB
resource "aws_lb" "alb-web" {
  name               = var.alb-web-name
  internal           = false
  load_balancer_type = "application"   # Application Load Balancer
  security_groups    = [aws_security_group.alb-sg-web.id]
  subnets            = [aws_subnet.pub-sub1.id, aws_subnet.pub-sub2.id]
}

resource "aws_lb" "alb-was" {
  name               = var.alb-was-name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg-was.id]
  subnets            = [aws_subnet.was-sub1.id, aws_subnet.was-sub2.id]
}

## ALB SG
resource "aws_security_group" "alb-sg-web" {  # Web ALB SG
  name        = var.alb-sg-web-name
  description = "ALB Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP from Web Tier"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from Web Tier"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.alb-sg-web-name
  }
}

resource "aws_security_group" "alb-sg-was" {  # WAS ALB SG
  name        = var.alb-sg-was-name
  description = "ALB Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "HTTP from Internet"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.asg-sg-web.id] # asg-security-group-web이라는 SG에 속한 인스턴스만이 이 포트를 통해 ALB에 접근할 수 있도록 제한하기
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.alb-sg-was-name
  }
}


# SSM 접속 위한 IAM
resource "aws_iam_role" "ec2_ssm_role" {
  name = "mk-EC2SSM"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
## IAM 역할 정책 연결
resource "aws_iam_role_policy_attachment" "ec2_ssm_policy_attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  ])

  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = each.key
}

## EC2 인스턴스 프로파일 생성
## EC2 인스턴스를 구분하고 그 인스턴스에 권한을 주기 위한 개념
## 인스턴스 프로파일이 지정된 EC2는 시작 시 역할 정보를 받아오고 해당 역할로 필요한 권한들을 얻게 됨
resource "aws_iam_instance_profile" "ec2_ssm_instance_profile" {
  name = "mk-EC2SSM-Instance-Profile"
  role = aws_iam_role.ec2_ssm_role.name
}


# Launch template
## Launch template- Web
resource "aws_launch_template" "template-web" {
  name          = var.launch-template-web-name
  image_id      = var.image-id
instance_type = var.instance-type


  ## 인스턴스 안에서 메타데이터 사용가능
  metadata_options {
    http_endpoint               = "enabled"  # 인스턴스 메타데이터에 HTTP 엔드포인트를 사용하도록 설정
    http_tokens                 = "required" # http_tokens: 메타데이터 요청에 대해 토큰을 필요로 함 (보안 강화)
    http_put_response_hop_limit = 1          # 메타데이터 서비스에 대한 PUT 응답의 네트워크 홉 제한을 1로 설정 (메타데이터 서비스로의 PUT 요청이 다른 중간 네트워크 장치를 거치지 않고 바로 인스턴스로 전달됨. 이를 통해 외부에서의 비정상적인 접근을 방지할 수 있음)
    instance_metadata_tags      = "enabled"  # 인스턴스 메타데이터에 태그를 사용할 수 있도록 함
  }

  network_interfaces {
    device_index    = 0  #첫 번째 네트워크 인터페이스(0)를 지정
    security_groups = [aws_security_group.asg-sg-web.id]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm_instance_profile.name
  }

  
user_data = base64encode(templatefile("web-user-data.sh",{   # 사용자 데이터 스크립트는 인스턴스가 처음 시작할 때 실행됨. 이 스크립트는 "web-user-data.sh" 파일을 사용하고, 이 파일은 ALB의 DNS 이름을 인자로 받아 인코딩된 형태로 제공
    alb_dns = "${aws_lb.alb-was.dns_name}"
  }))

   depends_on = [
    aws_lb.alb-web       # alb-web 리소스가 생성된 후에 실행되도록 설정
  ]

  tag_specifications {

    resource_type = "instance"
    tags = {
      Name = var.web-instance-name
    }
  }
}

## Launch Template - WAS
resource "aws_launch_template" "template-was" {
  name          = var.launch-template-was-name
  image_id      = var.image-id
  instance_type = var.instance-type
  

  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.asg-sg-was.id]
    
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm_instance_profile.name
  }

 ## 인스턴스 안에서 메타데이터 사용가능
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  ## 인스턴스가 올바른 데이터베이스와 연결되도록 환경 변수를 설정
  user_data = base64encode(templatefile("app-user-data.sh",{
    host = "${local.host}"
    rds_endpoint = "${data.aws_db_instance.my_rds.endpoint}"
    username = "${var.db-username}"
    password = "${var.db-password}"
    db = "${var.db-name}"
  }))

   depends_on = [
    aws_db_instance.rds-db
  ]

  tag_specifications {

    resource_type = "instance"
    tags = {
      Name = var.was-instance-name
    }
  }
}

## locals 블록을 사용하여 로컬 변수를 정의
## 코드 내에서 재사용할 값을 정의
locals {
rds_endpoint = "${data.aws_db_instance.my_rds.endpoint}"
# AWS RDS 인스턴스의 엔드포인트 값을 할당받기 (이 값은 보통 RDS 인스턴스에 접속하기 위한 주소와 포트 번호 포함)
host = replace(local.rds_endpoint, ":3306", "")
# local.rds_endpoint에서 포트 번호 (:3306)를 제거하여 생성 
}


# Target Group
## TG-Web
resource "aws_lb_target_group" "tg-web" {
  name     = var.tg-web-name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    path    = "/"
    matcher = "200-299"      # health check 위해 기대되는 http 응답 코드 범위(200~299: 성공적인 응답)
    interval = 5             # 5초마다 health check 수행
    timeout = 3              # 3초 내에 반환하지 않으면 실패로 간주
    healthy_threshold = 3    # 성공적인 health check 횟수(연속적으로 건강한 것으로 간주되기 위함)
    unhealthy_threshold = 5  # 실패한 health check 횟수(연속적으로 비건강한 것으로 간주되기 위함)
  }
}

## HTTPS 프로토콜을 사용하므로 이를 받아줄 리스너
## default action으로 404 페이지 출력
resource "aws_lb_listener" "myhttps" {
  load_balancer_arn = aws_lb.alb-web.arn
  port              = 443
  protocol          = "HTTPS"
 
  ssl_policy       = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.example.arn
 
  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"   # 고정된 응답을 반환

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - MK"
      status_code  = 404
    }
  }
}

## HTTPS 리스너 규칙 생성
## Target 그룹으로 포워딩
resource "aws_lb_listener_rule" "https-rule" {
  listener_arn = aws_lb_listener.myhttps.arn
  priority     = 100
 
  condition {
    path_pattern {         # 요청의 경로 패턴에 따라 규칙을 적용할지 결정
      values = ["*"]       # 모든 경로(*)에 대해 이 규칙을 적용 (이 리스너로 들어오는 모든 요청에 대해 이 규칙이 적용)
    }
  }
 
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg-web.arn
  }
}

## HTTP 프로토콜 리스너(모든 HTTP 트래픽을 HTTPS로 리디렉션)
## default action으로 404 페이지 출력
resource "aws_lb_listener" "myhttp" {
  load_balancer_arn = aws_lb.alb-web.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "redirect"   #  트래픽을 다른 위치로 리디렉션

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"   # 301 상태 코드는 영구적인 리디렉션
    }
  }
}

## TG-WAS
resource "aws_lb_target_group" "tg-was" {
  name     = var.tg-was-name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    path    = "/"
    matcher = "200-299"
    interval = 5
    timeout = 3
    healthy_threshold = 3
    unhealthy_threshold = 5

  }
}

resource "aws_lb_listener" "alb_listener-was" {
  load_balancer_arn = aws_lb.alb-was.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-was.arn
  }
}


# Auto Scaling Group, Auto Scaling Group SG
## ASG-Web
resource "aws_autoscaling_group" "asg-web" {
  name                = var.asg-web-name
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  target_group_arns   = [aws_lb_target_group.tg-web.arn]
  health_check_type   = "EC2"
  vpc_zone_identifier = [aws_subnet.web-sub1.id, aws_subnet.web-sub2.id]

  tag {
    key                 = "asg-web-key"
    value               = "asg-web-value"
    propagate_at_launch = true  
# ASG에서 생성된 EC2 인스턴스에 태그를 자동으로 적용할지에 대한 여부 지정
  }

  launch_template {
    id      = aws_launch_template.template-web.id
    version = aws_launch_template.template-web.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}

## ASG-Web-SG
resource "aws_security_group" "asg-sg-web" {
  name        = var.asg-sg-web-name
  description = "ASG Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg-web.id]
  }

  ingress {
    description = "SSH From Anywhere or Your-IP"  # 원격으로 서버 접속해 SW 업데이트, 구성 변경 등 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.asg-sg-web-name
  }
}

# ASG-WAS
resource "aws_autoscaling_group" "asg-was" {
  name                = var.asg-was-name
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  target_group_arns   = [aws_lb_target_group.tg-was.arn]
  health_check_type   = "EC2"
  vpc_zone_identifier = [aws_subnet.was-sub1.id, aws_subnet.was-sub2.id]
  
  tag {
    key                 = "asg-app-Key"
    value               = "asg-app-Value"
    propagate_at_launch = true
  }

  launch_template {
    id      = aws_launch_template.template-was.id
    version = aws_launch_template.template-was.latest_version
    
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50  # 인스턴스 갱신 중에 항상 최소 50%의 인스턴스가 정상 상태를 유지하도록 설정
    }
    triggers = ["tag"]
  }
}

# ASG-WAS-SG
resource "aws_security_group" "asg-sg-was" {
  name        = var.asg-sg-was-name
  description = "ASG Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg-was.id]  # was alb sg에서 오는 트래픽
  }

  ingress {
    description     = "SSH From Anywhere or Your-IP"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.asg-sg-web.id]  # web asg sg에서 오는 트래픽
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.asg-sg-was-name
  }
}


# DB SG, DB Subnet Group
## DB-SG
resource "aws_security_group" "db-sg" {
  name        = var.db-sg-name
  description = "DB Security Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.asg-sg-was.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.db-sg-name
  }
}

## DB-Subnet-Group
resource "aws_db_subnet_group" "db-sub-grp" {
  name       = var.db-sub-grp-name
  subnet_ids = [aws_subnet.db-sub1.id,aws_subnet.db-sub2.id]

  tags = {
    Name = var.db-sub-grp-name
  }
}


# RDS 파라미터 그룹
resource "aws_db_parameter_group" "mk-par-grp" {
  name        = "mk-par-grp"
  family      = "mysql8.0"
  description = "Example parameter group for mysql8.0"
  
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  
  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }
}

# RDS
## RDS 데이터 소스 정의
data "aws_db_instance" "my_rds" {
  db_instance_identifier = aws_db_instance.rds-db.identifier
}

resource "aws_db_instance" "rds-db" {
  allocated_storage      = 20
  db_name                = var.db-name
  engine                 = "mysql"
  engine_version         = "8.0"
  storage_type           = "gp3"  // General Purpose SSD (gp3)
  instance_class         = var.instance-class
  username               = var.db-username
  password               = var.db-password
  parameter_group_name   = aws_db_parameter_group.mk-par-grp.name
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.db-sub-grp.name
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  skip_final_snapshot    = true
  identifier             = "mk-rds-instance" // RDS 인스턴스의 이름 지정
}


# Route 53, ACM
## ACM 인증서 생성
resource "aws_acm_certificate" "example" {
  domain_name       = "mkcloud.site"
  validation_method = "DNS"
}

## ACM 검증
resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.example.arn
  
}
  

data "aws_route53_zone" "example" {
  name         = "mkcloud.site"
  private_zone = false
}

## ACM 검증을 위한 CNAME 레코드 생성
resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.example.zone_id
}

resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.example.zone_id
  name    = "mkcloud.site"
  type    = "A"  # ALIAS 레코드는 A 또는 AAAA 타입을 사용합니다.

  alias {
    name                   = aws_lb.alb-web.dns_name
    zone_id                = aws_lb.alb-web.zone_id
    evaluate_target_health = true
  }

#  ttl     = 86400  # ALIAS 레코드에는 필요하지 않지만, 일관성을 위해 기재 가능
}


# Output
## 특정 값이나 속성을 테라폼 실행 결과의 출력으로 내보내기 위해 사용

output "web-alb-dns" {
  value = aws_lb.alb-web.dns_name
}

output "rds-endpoint" {
  value = data.aws_db_instance.my_rds.endpoint
}
