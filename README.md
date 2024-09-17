# AWS-Network-Firewall-Inspection

![AWS-Network-Firewall-Inspection](https://github.com/user-attachments/assets/2cabee37-8a25-46e1-83c4-f6c9e8f4877f)


## Key Components 
- 2 EC2 instances
- VPC, IGW, 2 Firewall Subnets with different AZs, 2 Server Subnets with different AZs
- Ingress Route Table, Firewall Route Table, 2 Server Route Tables
- AWS Network Firewall, Firewall Policy, Firewall Rule Group

## Goals
- Direct all the incoming traffic to AWS Network Firewall to be inspected. (For North-South Traffic)
- Direct all the traffic between Server-A and Server-B to go through AWS Network Firewall to be inspected. (For East-West Traffic)

## Verify the traffic flow using AWS Network Firewall Rule Group
- Add a network firewall rule to block traffic between Server-A and B to verify that the traffic is actually going through Network Firewall. (For East-West Traffic)
- EC2 instances must have internet access. (For North-South Traffic)
