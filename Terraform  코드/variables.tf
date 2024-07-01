
variable "vpc-cidr" {
  description = "CIDR Block for VPC"
}

variable "vpc-name" {
  description = "Name for Virtual Private Cloud"
}

variable "az-a" {
  description = "Availabity Zone a"
}

variable "az-c" {
  description = "Availabity Zone c"
}

# Public Subnet
variable "pub-sub1-cidr" {
  description = "CIDR Block for Public Subnet 1"
}

variable "pub-sub1-name" {
  description = "Name for Public Subnet 1"
}

variable "pub-sub2-cidr" {
  description = "CIDR Block for Public Subnet 2"
}

variable "pub-sub2-name" {
  description = "Name for Public Subnet 2"
}

# IGW
variable "igw-name" {
  description = "Name for Internet Gateway"
}

# NAT GW
variable "nat-gw1-name" {
  description = "Name for NAT Gateway 1"
}
variable "nat-gw2-name" {
  description = "Name for NAT Gateway 2"
}

# Web
variable "web-sub1-cidr" {
  description = "CIDR Block for Web Subnet 1"
}

variable "web-sub1-name" {
  description = "Name for Web Subnet 1"
}

variable "web-sub2-cidr" {
  description = "CIDR Block for Web Subnet 2"
}

variable "web-sub2-name" {
  description = "Name for Web Subnet 2"
}

variable "web-instance-name" {
  description = "Value for Web Instances"
}


# WAS
variable "was-sub1-cidr" {
  description = "CIDR Block for WAS Subnet 1"
}

variable "was-sub1-name" {
  description = "Name for WAS Subnet 1"
}

variable "was-sub2-cidr" {
  description = "CIDR Block for WAS Subnet 2"
}

variable "was-sub2-name" {
  description = "Name for WAS Subnet 2"
}

variable "was-instance-name" {
  description = "Value for App Instances"
}

# DB
variable "db-sub1-cidr" {
  description = "CIDR Block for DB Subnet 1"
}

variable "db-sub1-name" {
  description = "Name for DB Subnet 1"
}

variable "db-sub2-cidr" {
  description = "CIDR Block for DB Subnet 2"
}

variable "db-sub2-name" {
  description = "Name for DB Subnet 2"
}

variable "db-username" {
  description = "Username for db instance"
}

variable "db-password" {
  description = "Password for db instance"
}

variable "db-name" {
  description = "Name for Database"
}

variable "db-sub-grp-name" {
  description = "Name for DB Subnet Group"
}

variable "db-sg-name" {
  description = "Name for DB Security group"
}

variable "instance-class" {
  description = "Value for DB instance class"
}

# RT
variable "pub-rt-name" {
  description = "Name for Public Route table"
}

variable "pri-rt1-name" {
  description = "Name for Private Route table 1"
}

variable "pri-rt2-name" {
  description = "Name for Private Route table 2"
}

# ALB
variable "alb-web-name" {
  description = "Application Load Balancer's name for the Web instance"
}

variable "alb-sg-web-name" {
  description = "Name for alb security group 1"
}

variable "alb-was-name" {
  description = "Application Load Balancer's name for the WAS instance"
}

variable "alb-sg-was-name" {
  description = "Name for alb security group 1"
}

# ASG
variable "asg-web-name" {
  description = "Name the Auto Scaling group in Web Tier"
}

variable "asg-sg-web-name" {
  description = "Name for asg security group 1"
}
variable "asg-was-name" {
  description = "Name the Auto Scaling group in was Tier"
}

variable "asg-sg-was-name" {
  description = "Name for asg security group 1"
}

# tg
variable "tg-web-name" {
  description = "Name for Target group web"
}

variable "tg-was-name" {
  description = "Name for Target group was"
}

# launch template
variable "launch-template-web-name" {
  description = "Name for Launch-template-1"
}
variable "image-id" {
  description = "Value for Image-id"
}

variable "instance-type" {
  description = "Value for Instance type"
}

variable "launch-template-was-name" {
  description = "Name for Launch-template-1"
}
