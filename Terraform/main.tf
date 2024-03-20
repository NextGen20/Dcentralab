provider "aws" {
  region = var.aws_region
}

// EC2 amazon linux instance with boot user data of nginx that provide "Ok" page. 
resource "aws_instance" "webapp_instance" {
  ami                    = var.ami_id 
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.private_subnet.id
  security_groups        = [aws_security_group.ec2_sg.name]

  user_data = <<-EOF
             #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              echo '<html><body><h1>Ok</h1></body></html>' > /usr/share/nginx/html/index.html
              docker run -d -p 80:80 -v /usr/share/nginx/html:/usr/share/nginx/html:ro --name webserver nginx
              EOF
}

// database mysql with all the setting
resource "aws_db_instance" "mysql_db" {
  allocated_storage    = var.rds_allocated_storage
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.rds_instance_type
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

//private subnet
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db_subnet_group"
  subnet_ids = [aws_subnet.private_subnet.id]
}

