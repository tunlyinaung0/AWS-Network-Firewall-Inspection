resource "aws_networkfirewall_rule_group" "rule-group" {
    name = "${var.prefix}-rule-group"
    capacity = 100
    type = "STATELESS"


    tags = {
        Name = "${var.prefix}-rule-group"
    }

    rule_group {
        rules_source {
            stateless_rules_and_custom_actions {
                stateless_rule {
                    priority = 10
                    rule_definition {
                        actions = ["aws:pass"]

                        match_attributes {
                            source {
                                address_definition = "ANY"
                            }

                            source_port {
                                from_port = 0
                                to_port = 65535
                            }

                            destination {
                                address_definition = "ANY"
                            }

                            destination_port {
                                from_port = 0
                                to_port = 65535
                            }

                            protocols = []
                        }
                    }
                }
            }
        }
    }
}


resource "aws_networkfirewall_firewall_policy" "policy" {
    name = "${var.prefix}-policy"
    firewall_policy {
        stateless_default_actions = ["aws:foward_to_sfe"]
        stateless_fragment_default_actions = ["aws:drop"]
        stateless_rule_group_reference {
            priority = 10
            resource_arn = aws_network_firewall_rule_group.rule-group.arn
        }
    }

    tags = {
        Name = "${var.prefix}-policy"
    }
}


resource "aws_networkfirewall_firewall" "firewall" {
    name = "network-firewall"
    firewall_policy_arn = aws_networkfirewall_firewall_policy.policy.arn
    vpc_id = aws_vpc.main.id
    subnet_change_protection = true

    subnet_mapping {
        subnet_id = aws_subnet.firewall-subnet-a.id
        ip_address_type = "IPV4"
    }
    
    subnet_mapping {
        subnet_id = aws_subnet.firewall-subnet-b.id
        ip_address_type = "IPV4"
    }


}

data "aws_vpc_endpoint" "gwlbe1" {
    vpc_id = aws_vpc.main.id
    service_name = aws_networkfirewall_firewall.firewall.firewall_status[0].synced_state[aws_subnet.firewall-subnet-a].attachment.endpoint_id
}

data "aws_vpc_endpoint" "gwlbe2" {
    vpc_id = aws_vpc.main.id
    service_name = aws_networkfirewall_firewall.firewall.firewall_status[0].synced_state[aws_subnet.firewall-subnet-b].attachment.endpoint_id
}