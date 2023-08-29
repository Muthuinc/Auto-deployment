# Region for the resources
variable "region"{
    default = "ap-southeast-2"
}

# CIDR block for the vpc
variable "vpc_cidr_block" {
    description = "vpc cidr block"
    type = string
    default = "10.0.0.0/16"
}

# tenancy for the VPC
variable "vpc_instance_tenancy"{
    description = "tenancy value"

    default = "default"
}

# This is the tag name of the VPC
variable "vpc_name"{
    default = "abigaile"
}

#--------------------------------------------

#Subnet 1 CIDR block for the vpc
variable "sub1_cidr_block" {
    description = "sub cidr block"
    type = string
    default = "10.0.0.0/24"
}

variable "subnet1_availablity_zone" {
    default = "ap-southeast-2a"
}

# This is the tag name of the subnet1
variable "subnet1_name"{
    default = "Pub1"
}

#-------------------------------------------

#Subnet 2 CIDR block for the vpc
variable "sub2_cidr_block" {
    description = "subnet2 cidr block"
    type = string
    default = "10.0.1.0/24"
}

variable "subnet2_availablity_zone" {
    default = "ap-southeast-2b"
}

# This is the tag name of the subnet1
variable "subnet2_name"{
    default = "Pub2"
}

#-----------------------------------------

#Subnet 3 CIDR block for the vpc
variable "sub3_cidr_block" {
    description = "subnet3 cidr block"
    type = string
    default = "10.0.2.0/24"
}

variable "subnet3_availablity_zone" {
    default = "ap-southeast-2c"
}

# This is the tag name of the subnet1
variable "subnet3_name"{
    default = "Pub3"
}

#----------------------------------------

variable "routetable" {
    default = "0.0.0.0/0"
}

variable "myip" {
    default = ["1.38.103.41/32"]
}

variable "app_port" {
    default = "5000"
}

variable "secruity_group_name" {
    default = "prod"
}

#--------------------------------------

variable "instance_ami" {
    default = "ami-0310483fb2b488153"
}
variable "instance_type" {
    default = "t2.micro"
}
variable "key_name"{
    default = "Ava"
}
variable "instance_tag" {
    default = "app1"
}