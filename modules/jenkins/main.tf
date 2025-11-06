data "aws_ami" "amazon_linux_2023_arm" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-arm64"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_key_pair" "jenkins" {
  key_name   = "jenkins-key"
  public_key = var.jenkins_ssh_public_key
  tags       = merge(var.common_tags, { Name = "jenkins-key" })
}

resource "aws_security_group" "jenkins_sg" {
  name   = "jenkins-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

  tags = merge(var.common_tags, { Name = "jenkins-sg" })
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.amazon_linux_2023_arm.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.jenkins.key_name

  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  root_block_device {
    volume_size           = 10
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(var.common_tags, { Name = "jenkins" })
}

resource "aws_ebs_volume" "jenkins_data" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 8
  type              = "gp3"
  encrypted         = true

  tags = merge(var.common_tags, { Name = "jenkins-data" })
}

resource "aws_volume_attachment" "jenkins_data" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.jenkins_data.id
  instance_id = aws_instance.jenkins.id
}