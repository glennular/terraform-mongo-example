module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  name = "mongo-vpc"

  cidr = "10.1.0.0/16"

  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.11.0/24", "10.1.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

module "mongodb" {
  source = "./modules/mongodb"

  # What are we making
  mongo_name                     = "mongo"
  mongo_count                    = "1"
  mongo_ami                      = "ami-00c03f7f7f2ec15c3"
  mongo_instance_type            = "t2.micro"
  mongo_app_sg_name              = "mongo-sg"

  # Where to put it
  mongo_vpc_id                   = "${module.vpc.vpc_id}"
  mongo_subnet                   = "${module.vpc.private_subnets[0]}"

  # How to build the disks and VM resources
  mongo_volume_type              = "gp2"
  mongo_volume_size              = "10"
  mongo_ebs_volume               = "${aws_ebs_volume.mongo_ebs_volume.id}"
  mongo_availability_zone        = "a"
  # How to provision it
  #mongo_provisioning_key         = "${var.provisioning_key}"

  mongo_tags   = {} 
}
resource "aws_ebs_volume" "mongo_ebs_volume" {
  availability_zone = "${var.region}a"
  size              = 1
}
