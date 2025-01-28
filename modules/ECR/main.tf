module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "gitops"

  repository_read_write_access_arns = ["arn:aws:iam::058264364931:role/_LocalAdmin"]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = var.environment_tag
  }

  repository_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "ecr:BatchGetImage"
        Resource = "*"
        Principal = {
          AWS = "arn:aws:iam::058264364931:role/_LocalAdmin"
        }
      }
    ]
  })
}
