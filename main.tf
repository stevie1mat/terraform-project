provider "aws" {
  region = "us-east-1"
}

# VPC
module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.1.0.0/16"
  env_name = "Prod"
}

######################
# Subnets
######################

# Public Subnets (AZ a–d)
module "public_subnet_1" {
  source     = "./modules/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.1.1.0/24"
  az         = "us-east-1a"
  env_name   = "Prod"
  public     = true
}

module "public_subnet_2" {
  source     = "./modules/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.1.2.0/24"
  az         = "us-east-1b"
  env_name   = "Prod"
  public     = true
}

module "public_subnet_3" {
  source     = "./modules/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.1.3.0/24"
  az         = "us-east-1c"
  env_name   = "Prod"
  public     = true
}

module "public_subnet_4" {
  source     = "./modules/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.1.4.0/24"
  az         = "us-east-1d"
  env_name   = "Prod"
  public     = true
}

# Private Subnets (for DB + VM6)
module "private_subnet_1" {
  source     = "./modules/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.1.5.0/24"
  az         = "us-east-1a"
  env_name   = "Prod"
  public     = false
}

module "private_subnet_2" {
  source     = "./modules/subnet"
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.1.6.0/24"
  az         = "us-east-1b"
  env_name   = "Prod"
  public     = false
}

######################
# Security Group
######################
module "web_sg" {
  source      = "./modules/securitygroup"
  name        = "WebSG"
  description = "Allow HTTP and SSH"
  vpc_id      = module.vpc.vpc_id
  env_name    = "Prod"
  ingress_rules = [
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]
  egress_rules = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

######################
# EC2 Instances
######################

# Web Servers
module "web1" {
  source              = "./modules/ec2"
  name                = "Webserver1"
  ami_id              = "ami-0c02fb55956c7d316"
  instance_type       = "t2.micro"
  subnet_id           = module.public_subnet_1.subnet_id
  sg_id               = module.web_sg.sg_id
  key_name            = "proj_new"
  env_name            = "Prod"
  associate_public_ip = true
}

module "web2" {
  source              = "./modules/ec2"
  name                = "Webserver2"
  ami_id              = "ami-0c02fb55956c7d316"
  instance_type       = "t2.micro"
  subnet_id           = module.public_subnet_2.subnet_id
  sg_id               = module.web_sg.sg_id
  key_name            = "proj_new"
  env_name            = "Prod"
  associate_public_ip = true
}

module "web3" {
  source              = "./modules/ec2"
  name                = "Webserver3"
  ami_id              = "ami-0c02fb55956c7d316"
  instance_type       = "t2.micro"
  subnet_id           = module.public_subnet_3.subnet_id
  sg_id               = module.web_sg.sg_id
  key_name            = "proj_new"
  env_name            = "Prod"
  associate_public_ip = true
}

module "web4" {
  source              = "./modules/ec2"
  name                = "Webserver4"
  ami_id              = "ami-0c02fb55956c7d316"
  instance_type       = "t2.micro"
  subnet_id           = module.public_subnet_4.subnet_id
  sg_id               = module.web_sg.sg_id
  key_name            = "proj_new"
  env_name            = "Prod"
  associate_public_ip = true
}

# Bastion
module "bastion" {
  source              = "./modules/ec2"
  name                = "BastionVM"
  ami_id              = "ami-0c02fb55956c7d316"
  instance_type       = "t2.micro"
  subnet_id           = module.public_subnet_2.subnet_id
  sg_id               = module.web_sg.sg_id
  key_name            = "proj_new"
  env_name            = "Prod"
  associate_public_ip = true
}

# DB Server
module "db_server" {
  source              = "./modules/ec2"
  name                = "DBServer5"
  ami_id              = "ami-0c02fb55956c7d316"
  instance_type       = "t2.micro"
  subnet_id           = module.private_subnet_1.subnet_id
  sg_id               = module.web_sg.sg_id
  key_name            = "proj_new"
  env_name            = "Prod"
  associate_public_ip = false
}

# VM6
module "vm6" {
  source              = "./modules/ec2"
  name                = "VM6"
  ami_id              = "ami-0c02fb55956c7d316"
  instance_type       = "t2.micro"
  subnet_id           = module.private_subnet_2.subnet_id
  sg_id               = module.web_sg.sg_id
  key_name            = "proj_new"
  env_name            = "Prod"
  associate_public_ip = false
}

######################
# Internet Gateway
######################
module "igw" {
  source   = "./modules/internet_gateway"
  vpc_id   = module.vpc.vpc_id
  env_name = "Prod"
  public_subnet_ids = {
    "subnet1" = module.public_subnet_1.subnet_id,
    "subnet2" = module.public_subnet_2.subnet_id,
    "subnet3" = module.public_subnet_3.subnet_id,
    "subnet4" = module.public_subnet_4.subnet_id
  }
}

######################
# Load Balancer
######################
module "alb" {
  source   = "./modules/alb"
  env_name = "Prod"
  subnet_ids = [
    module.public_subnet_1.subnet_id,
    module.public_subnet_2.subnet_id,
    module.public_subnet_3.subnet_id,
    module.public_subnet_4.subnet_id
  ]
  vpc_id = module.vpc.vpc_id
  sg_id  = module.web_sg.sg_id
}
