provider "aws" {
  region = var.region
}

resource "aws_db_subnet_group" "private_subnets" {
  subnet_ids = var.private_subnets

  tags = {
    Name = "Foo DB subnet group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "RDS security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_parameter_group" "postgres_parameter_group" {
  name   = "postgres-parameter-group"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = "postgres-instance"
  engine                  = "postgres"
  engine_version          = "13.3"
  instance_class          = "db.t3.micro"
  allocated_storage       = 10
  db_name                 = "foo_db"
  username                = "foo"
  password                = "foobarbaz"
  port                    = 5432
  db_subnet_group_name    = aws_db_subnet_group.private_subnets.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  parameter_group_name    = aws_db_parameter_group.postgres_parameter_group.name
  skip_final_snapshot     = true
  publicly_accessible     = false
  backup_retention_period = 1
  deletion_protection     = false
}
