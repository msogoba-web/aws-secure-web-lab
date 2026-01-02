terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.27.0"
    }
  }
}


provider "aws" { # creation de provider aws
  region = var.aws_region
}

resource "aws_vpc" "my_vpc" { # creation de reseau virtuel sur aws
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cloud-lab-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "cloud-lab-igw"
  }
}
resource "aws_subnet" "public" { # creation de sous reseau public dans le vpc
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "cloud-lab-public-subnet"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}


resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private" { # creation de sous-reseau prive dans le vpc dans la zone de disponibilite eu-west-3a
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "cloud-lab-public-subnet"
  }
}

resource "aws_eip" "nat_eip" { #creation d'un ip elastique pour le nat
  domain = "vpc"
}


resource "aws_nat_gateway" "nat" { # creation de passerelle nat
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "cloud-lab-nat"
  }
}

resource "aws_route_table" "private_rt" { # ajouter une regle sur la table de routage
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "web_sg" { # creation de groupe de securite 
  name   = "web-sg"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami                     = "ami-078abd88811000d7e"
  instance_type           = "t3.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name= "public-ec2"
  }
}
resource "aws_instance" "my_instance1" {
  ami                     = "ami-078abd88811000d7e"
  instance_type           = "t3.micro"
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  
  tags = {
    Name= "private-ec2"
  }
}