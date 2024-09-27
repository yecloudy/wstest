variable "ws-azs" {
  type = list
  default = ["us-west-2a","us-west-2b"]
}
variable "cidrlist" {
  type = list
  default = ["10.10.1.0/24","10.10.2.0/24"]
}
variable "vpc_cidr" {
   type = string
   default ="10.10.0.0/16"
}
variable "public_key_path" {
   type = string
   default="./key/id_rsa.pub"
}
variable "private_key_path" {
   type = string
   default="./key/id_rsa"
}
