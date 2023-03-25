# Configure the AWS provider
provider "aws" {
  region = var.region  # Replace with the region you want to use
}

# Create an IAM role to give EC2 instance permissions to access ECR
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the required policies to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ec2_role.name
}

# Create a security group that allows inbound traffic on port 8080 and egress traffic on all ports.
# Could also be cleaned up to only allow traffic from the load balancer
resource "aws_security_group" "app_sg" {
  name_prefix = "{var.project_name}_app_sg"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
resource "aws_instance" "myapp_instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = "{var.project_name}-test-key"
  security_groups = [aws_security_group.scholar_app_sg.name]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.module}/${var.key_pair_pem_file}")
      host        = self.public_ip
    }

    inline = [
      "echo 'Running provisioner'",
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo systemctl enable docker",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\"",
      "sudo unzip awscliv2.zip",
      "sudo ./aws/install",
      "echo 'Provisioning complete'",
    ]
  }
}

# Create an IAM instance profile to attach the IAM role to the EC2 instance
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}_ec2_profile"
  role = aws_iam_role.ec2_role.name
}