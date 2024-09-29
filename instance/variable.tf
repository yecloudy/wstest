variable "cidrlist" {
  type = list
}

variable "ami" {
  type = string
  default = "ami-08d8ac128e0a1b91c"
}
variable "subnet_id"{
  type = list
}
variable "availability_zone"{
  type = list
}

variable "public_key_path" {
  type = string
  default="../key/id_rsa.pub"
}
variable "vpc_id" {
  type = string
}
variable "mysql_ip" {
  type = string
}

variable "key_name" {
  type = string
}
