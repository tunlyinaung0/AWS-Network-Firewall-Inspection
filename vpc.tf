resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "${var.prefix}-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.prefix}-igw"
    }
}

resource "aws_subnet" "server-subnet-a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.server-subnet-a
    availability_zone = "us-east-1a"

    tags = {
        Name = "server-subnet-a"
    }
}

resource "aws_subnet" "server-subnet-b" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.server-subnet-b
    availability_zone = "us-east-1b"

    tags = {
        Name = "server-subnet-b"
    }
}

resource "aws_subnet" "firewall-subnet-a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.firewall-subnet-a
    availability_zone = "us-east-1a"   

    tags = {
        Name = "firewall-subnet-a"
    }
}

resource "aws_subnet" "firewall-subnet-b" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.firewall-subnet-b
    availability_zone = "us-east-1b"

    tags = {
        Name = "firewall-subnet-b"
    }
  
}

###########################################################################################
resource "aws_route_table" "ingress-rtb" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = var.server-subnet-a
        gateway_id = data.aws_vpc_endpoint.gwlbe1.id
    }

    route {
        cidr_block = var.server-subnet-b
        gateway_id = data.aws_vpc_endpoint.gwlbe2.id
    }

    tags = {
        Name = "${var.prefix}-ingress-rtb"
    }
  
}

resource "aws_route_table_association" "ingress-rtb-association" {
    gateway_id = aws_internet_gateway.igw.id
    route_table_id = aws_route_table.ingress-rtb.id
}

###########################################################################################

resource "aws_route_table" "firewall-rtb" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "firewall-rtb"
    }
}

resource "aws_route_table_association" "firewall-rtb-association" {
    subnet_id = aws_subnet.firewall-subnet-a.id
    route_table_id = aws_route_table.firewall-rtb.id
}

resource "aws_route_table_association" "firewall-rtb-association-b" {
    subnet_id = aws_subnet.firewall-subnet-b.id
    route_table_id = aws_route_table.firewall-rtb.id
}

###########################################################################################

resource "aws_route_table" "server-a-rtb" {
    vpc_id = aws_vpc.main.id

    # For North-South Traffic
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_vpc_endpoint.gwlbe1.id
    }

    # For East-West Traffic
    route {
        cidr_block = var.server-subnet-b
        gateway_id = data.aws_vpc_endpoint.gwlbe1.id

    }

    tags = {
        Name = "server-a-rtb"
    }

}

resource "aws_route_table_association" "server-a-rtb-association" {
    subnet_id = aws_subnet.server-subnet-a.id
    route_table_id = aws_route_table.server-a-rtb.id
}

###########################################################################################

resource "aws_route_table" "server-b-rtb" {
    vpc_id = aws_vpc.main.id

    # For North-South Traffic
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_vpc_endpoint.gwlbe2.id
    }

    # For East-West Traffic
    route {
        cidr_block = var.server-subnet-a
        gateway_id = data.aws_vpc_endpoint.gwlbe1.id

    }

    tags = {
        Name = "server-b-rtb"
    }

}

resource "aws_route_table_association" "server-b-rtb-association" {
    subnet_id = aws_subnet.server-subnet-b.id
    route_table_id = aws_route_table.server-b-rtb.id
}

###########################################################################################

resource "aws_security_group" "instance-sg" {
    name = "${var.prefix}-instance-sg"
    vpc_id = aws_vpc.main.id   

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "instance-sg"
    }
}