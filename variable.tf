variable "ws-azs" {
  type = list
  default = ["us-west-2a","us-west-2b"]

  validation {
    condition     = length(var.ws-azs) ==2
    error_message = "Invalid setting: The number of ws-azs must be 2"
  }
}
variable "cidrlist" {
  type = list
  default = ["10.10.1.0/24","10.10.2.0/24"]
  validation {
    condition     = alltrue([
      for cidr in var.cidrlist: can(cidrnetmask(cidr))
    ])
    error_message = "Invalid setting: All cidr must be valid IPv4 CIDR block addresses."
  }
  validation {
    condition     = length(var.cidrlist) ==2
    error_message = "Invalid setting: The number of cidrlist must be 2"
  }
}
variable "vpc_cidr" {
   type = string
   default ="10.10.0.0/16"

   validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Invalid setting: vpc_cidr must be valid IPv4 CIDR block addresses."
   }
}

# for https listener
variable "certificate_arn" {
   type = string
   default ="arn:aws:acm:us-west-2:842376562637:certificate/710f50b0-10ad-4b23-b29a-4e03f607b7b7"
}

variable "ami" {
   type = string
   default = "ami-08d8ac128e0a1b91c"
}

variable "public_key_path" {
  type = string
  default="./key/id_rsa.pub"
}

variable "mysql_ami" {
   type = string
   default = "ami-033067239f2d2bfbc"
}
