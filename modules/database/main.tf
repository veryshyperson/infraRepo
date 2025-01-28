
resource "aws_security_group" "rds_sg" {
  vpc_id = var.vpc_id
    ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_secretsmanager_secret" "rds_secret" {
  name = "db-creds"
}

data "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id = data.aws_secretsmanager_secret.rds_secret.id
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_secret_version.secret_string)
}


module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.db_name
  
  skip_final_snapshot = true
  
  engine            = var.db_engine
  engine_version    = "8.0"
  instance_class    = var.db_type
  allocated_storage = 5
  port     = "3306"

  db_name  = var.db_name
  username = local.db_credentials["DB_USERNAME"]
  password = local.db_credentials["DB_PASSWORD"]


  manage_master_user_password = false
  iam_database_authentication_enabled = false

  vpc_security_group_ids = [aws_security_group.rds_sg.id]


  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = var.stamp
    Environment = var.environment_tag
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = var.private_subnets

  # DB option group
  major_engine_version = var.db_engine_version
  create_db_option_group = false

  # DB parameter group
  family = "mysql8.0"
  create_db_parameter_group = false

  # Database Deletion Protection
  deletion_protection = false

}


#aws eks --region us-east-1  update-kubeconfig --name virgin-eks --role-arn arn:aws:iam::058264364931:role/_LocalAdmin