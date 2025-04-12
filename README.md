# ACS730 Final Project – Terraform Infrastructure Provisioning

## 👨‍💻 Project Title
Provisioning a Two-Tier AWS Architecture Using Terraform

---

## 🧠 Team Information

- **Name:** Deepika Paneer Selvam
- **Student Id:** 141586248
- **Institution:** Seneca College  
- **Course:** ACS730 – Cloud Automation and Control Systems  
- **Semester:** Winter 2025

---

- **Name:** Steven Mathew  
- **Student Id:** 170069231
- **Institution:** Seneca College  
- **Course:** ACS730 – Cloud Automation and Control Systems  
- **Semester:** Winter 2025



---

## 🎯 Objective

The goal of this project is to use Terraform to automate the deployment of a secure, scalable two-tier architecture on AWS. This includes creating VPCs, public and private subnets, Internet Gateway, NAT Gateway, Application Load Balancer, EC2 instances, and security groups — all through Infrastructure as Code (IaC).

---

## 📂 Project Structure

```bash
terraform-final-project/
├── main.tf                  # Primary Terraform configuration
├── variables.tf             # Input variable declarations
├── outputs.tf               # Output values for resources
├── backend.tf               # Remote backend setup (optional)
├── modules/
│   ├── vpc/                 # VPC and subnets
│   ├── internet_gateway/    # IGW + public route table
│   ├── nat/                 # NAT Gateway + private routing
│   ├── ec2/                 # EC2 instance configuration
│   ├── alb/                 # Load balancer, listeners, target groups
│   └── securitygroup/       # Security groups for all tiers
├── terraform.tfstate        # Terraform state file (not pushed to GitHub)
├── .gitignore               # Excludes sensitive files from version control
└── README.md                # Project documentation
```

## 🚀 Steps to Run the Terraform Code

### 1. Connect to Cloud9 or EC2 Instance
Ensure Cloud9 or your machine has AWS CLI configured or an IAM role attached.

```bash
aws configure
```
---

### 2. Initialize the Project

```bash
terraform init
```

---

### 3. Preview the Infrastructure

```bash
terraform plan
```

### 4. Apply the Terraform Plan
```bash
terraform apply -auto-approve
```
