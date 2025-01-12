provider "aws" {
  region = "us-east-1"
}

# Create a Key Pair
resource "tls_private_key" "progis_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "progis_key" {
  key_name   = "progis"
  public_key = tls_private_key.progis_key.public_key_openssh
}

# Save the private key locally
resource "local_file" "progis_key" {
  filename = "${path.module}/progis.pem"
  content  = tls_private_key.progis_key.private_key_pem
  file_permission = "0600"
}

# Create a Security Group
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

# Launch EC2 Instance
resource "aws_instance" "progress_db" {
  ami           = "ami-08c40ec9ead489470" # Ubuntu Server 22.04 LTS (Replace if needed)
  instance_type = "m5.xlarge"
  key_name      = aws_key_pair.progis_key.key_name

  security_groups = [aws_security_group.allow_ssh_http.name]

  tags = {
    Name = "ProgressDB-Instance"
  }

  user_data = file("${path.module}/scripts/install_progress.sh")
}
