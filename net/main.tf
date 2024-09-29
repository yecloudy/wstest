resource "aws_vpc" "vcp_ws" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.vcp_ws.id
  count = length(var.ws-azs)
  cidr_block = element(var.cidrlist, count.index)
  availability_zone = element(var.ws-azs, count.index)
  tags = {
    Name = "private-${count.index}"
  }
}


resource "aws_internet_gateway" "gw_ws" {
  vpc_id = aws_vpc.vcp_ws.id
  tags = {
     Name = "ws"
  }
}

resource "aws_route_table" "rttb_public" {
  vpc_id = aws_vpc.vcp_ws.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_ws.id
  }

  route {
   ipv6_cidr_block        = "::/0"
   gateway_id             = aws_internet_gateway.gw_ws.id
  }
  tags = {
    Name = "ws"
  }

}


resource "aws_route_table_association" "a_public" {
  count = length(var.cidrlist)
  subnet_id  = element(aws_subnet.public.*.id , count.index)
  route_table_id = aws_route_table.rttb_public.id
}
