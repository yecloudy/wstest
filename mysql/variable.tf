variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type     = string
  default     = "ami-033067239f2d2bfbc"
}


variable "public_key_path" {
  description = "The path to the public key file for SSH access"
  type        = string
}

variable "subnet_id" {
  type   = string
}

variable "vpc_id" {
  type   = string
}

variable "key_name" {
  type = string
}
