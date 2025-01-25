# Create a Security Group
resource "aws_security_group" "enugu_project_sg" {
  name        = "enugu-project-sg"
  description = "Security group for Enugu project instances"

  # Allow RDP (Windows) and SSH (Linux) access
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # RDP for Windows
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH for Linux
  }

  # Allow HTTP and HTTPS traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Enugu-Project-SG"
  }
}

# Create the first EC2 Instance: Enugu-project (Ubuntu)
resource "aws_instance" "enugu_project" {
  ami           = "ami-0ac80df6eff0e70b5"  # Updated to Ubuntu 20.04 LTS AMI (verify region)
  instance_type = "t3.xlarge"  # Changed to t3.xlarge (4 vCPUs)
  vpc_security_group_ids = [aws_security_group.enugu_project_sg.id]

  tags = {
    Name = "Enugu-project"
  }

  # Enable monitoring
  monitoring = true
}

# Create the second EC2 Instance: Enugu-pis
resource "aws_instance" "enugu_pis" {
  ami           = "ami-080e1f13689e07408"  # Check if this AMI is still available in your region
  instance_type = "t3.xlarge"  # Changed to t3.xlarge (4 vCPUs)
  vpc_security_group_ids = [aws_security_group.enugu_project_sg.id]

  tags = {
    Name = "Enugu-pis"
  }

  # Enable monitoring
  monitoring = true
}

# Create the third EC2 Instance: Enugu-server (Windows Server 2022)
resource "aws_instance" "enugu_server" {
  ami           = "ami-04b4f1a9cf54c11d0"  # Windows Server 2022 AMI (verify region)
  instance_type = "t2.large"  # Changed to t3.xlarge (4 vCPUs)
  vpc_security_group_ids = [aws_security_group.enugu_project_sg.id]

  tags = {
    Name = "Enugu-server"
  }

  # Enable monitoring
  monitoring = true

  # Define root block device (EBS)
  root_block_device {
    volume_type          = "gp2"
    volume_size          = 50
    delete_on_termination = true
  }
}

# Outputs
output "enugu_project_public_ip" {
  description = "Public IP of the Enugu-project EC2 instance"
  value       = aws_instance.enugu_project.public_ip
}

output "enugu_pis_public_ip" {
  description = "Public IP of the Enugu-pis EC2 instance"
  value       = aws_instance.enugu_pis.public_ip
}

output "enugu_server_public_ip" {
  description = "Public IP of the Enugu-server EC2 instance"
  value       = aws_instance.enugu_server.public_ip
}


