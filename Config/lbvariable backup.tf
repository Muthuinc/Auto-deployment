# Region for the resources
variable "region"{
    default = "ap-southeast-2"
}

variable "template_name"{
    default = "My_image"
}

variable "server_id" {
    default = "instance"
}

variable "vpc_id"{
    default = "hello"
}

variable "security_group_port"{
    default = "5000"
}

variable "access_ip"{
    default = ["0.0.0.0/0"]
}



variable "subnet_ids" {
  type    = list(string)
  default = ["sub1", "sub2"]
}
