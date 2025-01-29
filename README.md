# Terraform Infrastructure as Code (IaC)

![Terraform Logo](https://www.terraform.io/favicon.ico)

## Overview

This project provides a **super region-flexible and scalable Infrastructure as Code (IaC)** setup to provision an application under any circumstance. It covers various AWS services, including VPC networking, EKS clusters, RDS databases, and smart autoscaling with Karpenter. The architecture is designed to be modular and easily adaptable to different regions, with specific components like ArgoCD, AWS Load Balancer with NGINX, ACM, and Prometheus/Grafana integrations.

## Features

### 1. **Networking**
- **VPC**: Virtual Private Cloud for isolating resources.
- **Subnets**: Public and private subnets across multiple availability zones (AZs).
- **Internet Gateway (IGW)**: For routing public traffic.
- **NAT Gateway**: For secure outbound traffic from private subnets.
  
   (Note: Availability of specific features depends on the region. EKS support may not be available in all regions.)

### 2. **EKS Cluster**
- Managed Kubernetes (EKS) cluster, ready to deploy workloads.
- Configured to scale automatically and efficiently across availability zones.

### 3. **Blueprints**
- **Cluster StartPoint**: Pre-configured base for Kubernetes clusters.
- **EKS Add-ons**: Automatically installs EKS add-ons like ArgoCD, AWS LoadBalancer with NGINX, ACM for SSL management, and Prometheus/Grafana for monitoring.

### 4. **Karpenter (Smart Autoscaler)**
- **Karpenter**: Automatically provisions instances to meet your workload demands.
- **Cost-effective and scalable**: Ensure your application is always running optimally while reducing infrastructure costs.

### 5. **Database - RDS**
- Provision an **RDS MySQL Database Instance** securely stored in AWS.
- Fully managed and highly available for critical workloads.

## How to Use

1. Clone the repository.
2. Navigate to the `terraform` directory.
3. Customize your configuration files (e.g., `terraform.tfvars` for environment-specific settings).
4. Run the following Terraform commands:

   ```bash
   terraform init
   terraform plan
   terraform apply
