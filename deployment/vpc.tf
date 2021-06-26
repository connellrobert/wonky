variable "region" {
    default = "us-east-1"
    description = "AWS default region"
}

provider "aws" {
    region = "us-east-1"
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "wonky-k8s"
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "3.1.0"
  
    name = "wonky_vpc"
    cidr = "10.0.0.0/16"
    availability_zones = data.aws_availability_zones.available.names
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24","10.0.3.0/24"]
    public_subnets = ["10.0.4.0/24","10.0.5.0/24", "10.0.6.0/24"]
    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true
}

resource "aws_security_group" "k8s_priv_group_1" {
    vpc_id = module.vpc.vpc_id
    name = "k8s_priv_group_1"

    ingress {
        to_port = 0
        from_port = 0
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
  }
  
  resource "aws_security_group" "k8s_pub_group_1" {
      vpc_id = module.vpc.vpc_id
      name = "k8s_pub_group_1"

      ingress {
          to_port = 80
          from_port = 0
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          ipv6_cidr_blocks = ["::/0"]
      }
      egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
  }
  }
}

module "eks" {
    source = "terraform-aws-modules/eks/aws"
    cluster_name = local.cluster_name
    cluster_version = "1.2.0"
    subnets = module.vpc.private_subnets
    vpc_id = module.vpc.vpc_id
    
    worker_groups = [
        {
            name = ""
        }
    ]
}