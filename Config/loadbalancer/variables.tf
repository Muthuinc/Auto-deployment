# Region for the resources
variable "region"{
    default = "ap-southeast-2"
}

variable "template_name"{
    default = "My_image"          # AMI name
}

variable "server_id" {
       default = "instance"       # EC2 instance ID
}

variable "vpc_id"{
    default = "hello"             # VPC ID  (These will be replaced by the actual values by shell script )
}

variable "security_group_port"{
    default = "80"
}

variable "access_ip" {
    default = ["0.0.0.0/0"]
}




variable "subnet_ids" {
  type    = list(string)
  default = ["sub1", "sub2"]      # Subnets where the loadbalancer runs ( The sub1, sub2 will be replaced by actual values by the shell script)
}
