# AWS Region
variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

# VPC Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  description = "Availability Zones in the us-east-1 region for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# EC2 Instance Variables
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "instance_ami" {
  description = "AMI for EC2 instances"
  type        = string
  default     = "ami-080e1f13689e07408" # Ubuntu 22.04 LTS
}

variable "instance_ssh_key" {
  description = "NodeJS App production key"
  type        = string
  default     = "nodejs-app-prod-key"     
}

variable "asg_min_size" {
  description = "Minimum number of instances in the autoscaling group"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum number of instances in the autoscaling group"
  type        = number
  default     = 4
}

variable "asg_desired_capacity" {
  description = "Desired capacity for the auto scaling group"
  type        = number
  default     = 2                        
}

# Load Balancer Variables
variable "health_check_path" {
  description = "Health check path for the default target group"
  type        = string
  default     = "/"
}

# SNS Topic Variable (for Bonus Task)
variable "sns_notification_email" {
  description = "Email address to receive scaling notifications"
  type = list(string)
  default     = ["zilmotikko@gufum.com", "liyoro9415@storesr.com"]
}