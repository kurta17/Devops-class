resource "aws_key_pair" "main" {                                        
  1   key_name   = "harbour-space-devops-2025"                              
  2   public_key = file("~/.ssh/id_ed25519.pub")  # Terraform reads the file     directly
  3 }

resource "aws_security_group" "main" {
  name        = "allow-ssh-and-4444"
  description = "Allow SSH and port 4444 from anywhere"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Port 4444 from anywhere"
    from_port   = 4444
    to_port     = 4444
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh-and-4444"
  }
}

resource "aws_instance" "main" {
  ami           = "ami-00d8fc944fb171e29"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.main.id
  
  vpc_security_group_ids = [aws_security_group.main.id]

  tags = {
    Name = "HelloWorld"
  }
}
