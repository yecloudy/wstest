variable "ws-azs" {
  type = list
  default = ["us-west-2a","us-west-2b"]
}
variable "cidrlist" {
  type = list
}
variable "vpc_cidr" {
   type = string
}

variable "mysql_cidr" {
   type = string
   default = "10.10.3.0/24"
}
