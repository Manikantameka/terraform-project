# This section will create the subnet group for the RDS  instance using the private subnet
resource "aws_db_subnet_group" "main-rds" {
  name       = "main-rds"
  subnet_ids = [aws_subnet.private_subnet[2].id, aws_subnet.private_subnet[3].id]

 tags = merge(
    var.tags,
    {
      Name = "main-rds"
    },
  )
}

# create the RDS instance with the subnets group
resource "aws_db_instance" "main-rds" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "rotimidb"
  username               = var.master-username
  password               = var.master-password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.main-rds.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.datalayer-sg.id]
  multi_az               = "true"
}