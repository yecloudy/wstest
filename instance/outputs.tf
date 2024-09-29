output "instance_ids" {
  value = aws_instance.ws-inst.*.id
}
