
# 네트워크
vpc-cidr              = "10.0.0.0/16"
vpc-name              = "mk-vpc"
igw-name              = "mk-igw"
nat-gw1-name          = "mk-nat-gw1"
nat-gw2-name          = "mk-nat-gw2"

az-a                  = "ap-northeast-1a"
az-c                  = "ap-northeast-1c"

pub-sub1-cidr         = "10.0.1.0/24"
pub-sub1-name         = "mk-pub-sub1"
pub-sub2-cidr         = "10.0.2.0/24"
pub-sub2-name         = "mk-pub-sub2"

pub-rt-name           = "mk-pub-rt"
pri-rt1-name          = "mk-pri-rt1"
pri-rt2-name          = "mk-pri-rt2"

# Web
web-sub1-cidr         = "10.0.4.0/22"
web-sub1-name         = "mk-Web-sub1"
web-sub2-cidr         = "10.0.8.0/22"
web-sub2-name         = "mk-Web-sub2"
web-instance-name     = "mk-web-instances"

# WAS
was-sub1-cidr         = "10.0.12.0/22"
was-sub1-name         = "mk-WAS-sub1"
was-sub2-cidr         = "10.0.16.0/22"
was-sub2-name         = "mk-WAS-sub2"
was-instance-name     = "mk-was-instances"

# DB
db-sub1-cidr          = "10.0.20.0/22"
db-sub1-name          = "mk-DB-sub1"
db-sub2-cidr          = "10.0.24.0/22"
db-sub2-name          = "mk-DB-sub2"
db-username           = "mk"
db-password           = "mk1234567890"
db-name               = "mkdb"
db-sub-grp-name       = "mk-db-sub-grp"
db-sg-name            = "mk-db-sg"
instance-class        = "db.t3.micro"

# ALB
alb-web-name          = "mk-alb-web"
alb-sg-web-name       = "mk-alb-sg-web"
alb-was-name          = "mk-alb-was"
alb-sg-was-name       = "mk-alb-sg-was"

# ASG
asg-web-name             = "mk-asg-web"
asg-sg-web-name          = "mk-asg-sg-web"
asg-was-name             = "mk-asg-was"
asg-sg-was-name          = "mk-asg-sg-was"

# TG
tg-web-name              = "mk-tg-web"
tg-was-name              = "mk-tg-was"

# launch template
launch-template-web-name = "mk-launch-template-web"
image-id                 = "ami-02a405b3302affc24" # 최신 amazon linux2 ami-id
instance-type            = "t2.micro"
launch-template-was-name = "mk-launch-template-was"

