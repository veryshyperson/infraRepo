  region = "us-east-1"

  stamp = "virgin"
  domain = "bokertovmatoki.online"

  vpc_cidr = "10.0.0.0/16"

  repo_name = "tf-ecr-repo"
  ec2_type = "t2-medium"
  min_size = 1
  max_size = 4
  desired_size = 2

  db_engine = "mysql"
  db_name= "gitops"
  db_type = "db.t3.micro"
  db_engine_version = "8.0"

  environment_tag = "dev"