#################################################
# Variables for setting up a MongoDB instance
#################################################
#variable "mongo_provisioning_key" {
#    description = "A key that can be used to connect and provision instances in AWS."
#}

variable "mongo_name" {
    description = "Name of the mongodb instance"
}

variable "mongo_vpc_id" {
    description = "Target vpc id where the mongo db will live."
}

variable "mongo_count" {
    description = "How many mongodb instances to create."
}

variable "mongo_ami" {
    description = "The ami to use for the mongodb instance. Here we're just using an Ubuntu 14.04 LTS public image."
}

variable "mongo_instance_type" {
    description = "The instance type to use for the mongodb instance."
}

variable "mongo_volume_type" {
    description = "The volume type to use for data storage on the mongodb instance."
}

variable "mongo_volume_size" {
    description = "The volume size to use for the mongodb instance."
}

variable "mongo_subnet" {
    description = "The private subnet id where the mongodb instance will live"
}

variable "mongo_app_sg_name" {
    description = "Security group name for the mongodb instance"
}

variable "mongo_tags" {
  description = "Additional tags for the mongodb instance"
  default     = {}
}

variable "mongo_ebs_volume"  {
  
}
variable "mongo_availability_zone" {
  
}
