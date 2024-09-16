output "gwlbe1" {
    value = data.aws_vpc_endpoint.gwlbe1.id
}

output "gwlbe2" {
    value = data.aws_vpc_endpoint.gwlbe2.id
}


output "server-a-public-ip" {
    value = aws_instance.server-a.public_ip
}

output "server-b-public-ip" {
    value = aws_instance.server-b.public_ip
}