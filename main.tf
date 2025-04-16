provider "aws" {
  region = "us-east-1" # Or your actual region
}


# VPC
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  env_name = "Dev"
}

# Public Subnet 1 - for Webserver 1
module "public_subnet_1" {
  source     = "./modules/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.1.0/24"
  az         = "us-east-1a"
  env_name   = "Dev"
  public     = true
}

# Public Subnet 2 - for Webserver 3
module "public_subnet_2" {
  source     = "./modules/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.0.2.0/24"
  az         = "us-east-1b"
  env_name   = "Dev"
  public     = true
}

# Security Group for Webservers
module "web_sg" {
  source      = "./modules/securitygroup"
  name        = "WebSG"
  description = "Allow HTTP and SSH"
  vpc_id      = module.vpc.vpc_id
  env_name    = "Dev"
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# Webserver 1 (Subnet 1)
module "web1" {
  source              = "./modules/ec2"
  ami_id              = "ami-0c02fb55956c7d316" # Amazon Linux 2 AMI
  instance_type       = "t2.micro"
  subnet_id           = module.public_subnet_1.subnet_id
  sg_id               = module.web_sg.sg_id
  key_name            = "proj" # Just the key name, NOT .pem
  env_name            = "Dev"
  name                = "Webserver1"
  associate_public_ip = true
}

# Webserver 3 (Subnet 2)
module "web3" {
  source              = "./modules/ec2"
  ami_id              = "ami-0c02fb55956c7d316"
  instance_type       = "t2.micro"
  subnet_id           = module.public_subnet_2.subnet_id
  sg_id               = module.web_sg.sg_id
  key_name            = "proj"
  env_name            = "Dev"
  name                = "Webserver3"
  associate_public_ip = true
}

# Application Load Balancer
module "alb" {
  source     = "./modules/alb"
  env_name   = "Dev"
  subnet_ids = [module.public_subnet_1.subnet_id, module.public_subnet_2.subnet_id]
  vpc_id     = module.vpc.vpc_id
  sg_id      = module.web_sg.sg_id
}


module "igw" {
  source   = "./modules/internet_gateway"
  vpc_id   = module.vpc.vpc_id
  env_name = "Dev"
  public_subnet_ids = [
    module.public_subnet_1.subnet_id,
    module.public_subnet_2.subnet_id
  ]
}
