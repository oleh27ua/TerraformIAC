# TerraformIAC
Implementing Infrastructure using Terraform

## Scenario:
Imagine you're a DevOps engineer at a growing startup. The company has recently developed a new application and wants to leverage AWS for hosting the application. They need to set up and manage the infrastructure. Your task involves:
1. Using Terraform, describe the infrastructure for the following application: https://github.com/benc-uk/nodejs-demoapp
2. Set up and configure an EC2 Auto Scaling group, where the application will be run using Docker configured through EC2 user data.
The infrastructure should include:
   * Network and security groups for EC2 Auto Scaling group (you can use this module for reference or implementation: terraform-aws-modules/autoscaling/aws)
   * Load balancer and target group
Bonus Task: use Terraform to set up email notifications for scaling events using CloudWatch and SNS.

## The Structure of IAC:
``` 
└── root_folder
    ├── artillery
    │        └── load-test.yml
    ├── README.md
    ├── user_data
    │        └── user_data.sh
infrastructure/
├── common
│   ├── main.tf
│   ├── ec2.tf
│   ├── network.tf
│   ├── cloudwatch.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── sns.tf
├── env
│   ├──dev.tfvars
│   └──production.tfvars
├── production
│   ├── main.tf
│   ├── ec2.tf        -> common/ec2.tf
│   ├── network.tf    -> common/network.tf
│   ├── cloudwatch.tf -> common/cloudwatch.tf
│   ├── variables.tf  -> common/variables.tf
│   ├── outputs.tf    -> common/outputs.tf
│   └── sns.tf        -> common/sns.tf
└── dev
    ├── main.tf
    ├── ec2.tf        -> common/ec2.tf
    ├── network.tf    -> common/network.tf
    ├── cloudwatch.tf -> common/cloudwatch.tf
    ├── variables.tf  -> common/variables.tf
    ├── outputs.tf    -> common/outputs.tf
    └── sns.tf        -> common/sns.tf    
``` 

Note: Remember to add a meaningful name for each of the terraform resources in order to easily navigate through resources, not just “example_alb”, load balancer resource name, for example, “public_alb”.

Hint: use symlinks to link files from common to the environment.
