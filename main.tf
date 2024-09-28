provider "aws" {
  region = "us-west-2"
}

module "net" {
  source = "./net"
  ws-azs = var.ws-azs
  cidrlist = var.cidrlist
  vpc_cidr = var.vpc_cidr
}


module "alb" {
  source = "./alb"
  subnetlist = module.net.public_sub_ids
  vpc_id = module.net.vpc_id
  certificate_arn = var.certificate_arn
  instance_ids = module.instance.instance_ids
}

module "instance" {
  source = "./instance"
  ami = var.ami
  cidrlist = [element(var.cidrlist,0),element(var.cidrlist,1)]
  subnet_id = module.net.public_sub_ids
  availability_zone = [element(var.ws-azs,0),element(var.ws-azs,1)]
  public_key_path = var.public_key_path
  vpc_id = module.net.vpc_id
  mysql_ip = module.mysql.instance_private_ip
  key_name = aws_key_pair.pub_key.key_name
}

module "mysql" {
  source = "./mysql"
  ami_id = var.mysql_ami
  public_key_path = var.public_key_path
  subnet_id = element(module.net.public_sub_ids,1)
  vpc_id = module.net.vpc_id
  key_name = aws_key_pair.pub_key.key_name
}

resource "aws_key_pair" "pub_key" {
  key_name   = "ssh-key"
  public_key = "${file(var.public_key_path)}"
}
