output "server-a-public-ip" {
    value = aws_instance.server-a.public_ip
}

output "server-b-public-ip" {
    value = aws_instance.server-b.public_ip
}

output "gwlbe1_id" {
    value = (aws_networkfirewall_firewall.firewall.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[0]
}

output "gwlbe2_id" {
    value = (aws_networkfirewall_firewall.firewall.firewall_status[0].sync_states[*].attachment[0].endpoint_id)[1]
}