terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
  }

  provider "aws" {
    region = var.aws_region
  }

  resource "aws_security_group" "todo_sg" {
    name = "todo-api-sg"

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

    ingress {
      from_port   = 3001
      to_port     = 3001
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
   }

  }

  resource "aws_instance" "todo_server" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    key_name               = var.key_name
    subnet_id              = var.subnet_id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.todo_sg.id]

    tags = {
      Name = "todo-api-server"
    }
  }
