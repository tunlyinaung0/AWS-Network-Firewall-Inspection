resource "aws_instance" "server-a" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.server-subnet-a.id
    vpc_security_group_ids = [aws_security_group.instance-sg.id]
    associate_public_ip_address = true
    private_ip = "10.200.10.167"
    availability_zone = var.az1
    
    tags = {
        Name = "server-a"
    }
}


resource "aws_instance" "server-b" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.server-subnet-b.id
    vpc_security_group_ids = [aws_security_group.instance-sg.id]
    associate_public_ip_address = true
    private_ip = "10.200.11.167"
    availability_zone = var.az2
   
    tags = {
        Name = "server-b"
    }
}