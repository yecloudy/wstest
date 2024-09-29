output "vpc_id" {
  value = aws_vpc.vcp_ws.id
}
output "public_sub_ids" {
  value = aws_subnet.public.*.id

  precondition {
    condition = length(aws_subnet.public) == 2
    error_message = "There number of public subnet must be 2"
  }
}
