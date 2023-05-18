terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

variable "bucket_name" {
  description = "Value of the name tag for the bucket"
  type        = string
  default     = "week-2"
}

variable "keyPair_name" {
  description = "Value of the name of keyPair"
  type        = string
  default     = "MyKeyPair"
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3_read_access" {
  statement {
    actions = ["s3:Get*", "s3:List*"]

    resources = ["arn:aws:s3:::*"]
  }
}

resource "aws_iam_role" "ec2_iam_role" {
  name = "ec2_iam_role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy" "join_policy" {
  depends_on = [aws_iam_role.ec2_iam_role]
  name       = "join_policy"
  role       = aws_iam_role.ec2_iam_role.name

  policy = data.aws_iam_policy_document.s3_read_access.json
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "instance_profile"
  role = aws_iam_role.ec2_iam_role.name
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]

  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      description      = ""
      security_groups  = []
      self             = false
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      description      = ""
      security_groups  = []
      self             = false
  }]
}


resource "aws_instance" "app_server" {
  ami                    = "ami-02d5619017b3e5162"
  instance_type          = "t2.micro"
  key_name               = var.keyPair_name
  vpc_security_group_ids = [aws_security_group.main.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

  user_data = <<-EOT
    #!/bin/bash
    sudo su
    yum update -y
    aws s3 cp s3://week-2/ ./ --recursive
  EOT 

}


output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

