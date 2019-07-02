variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}


variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "ap-south-1"
}

variable "aws_az" {
    description = "EC2 AZ for the Region"
    default = "ap-south-1a"
}

variable "s3-location" {
    description = "S3 bucket for artifacts"
    default = "deployapp-th"
}

variable "nat_ami" {
    description = "NAT AMI"
    default = "ami-00b3aa8a93dd09c13"
}


variable "amis" {
    description = "AMIs by region"
    default = {
        ap-south-1 = "ami-0d2692b6acea72ee6" # ubuntu 14.04 LTS
    }
}

variable "s3role" {
    description = "s3role"
    default = "s3_Access"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}
