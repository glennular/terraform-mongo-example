# Create a security group with rules for the mongodb instance
# Ref https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html
resource "aws_security_group" "app_sg" {
  name        = "${var.mongo_app_sg_name}"
  description = "Security group for the mongo db server"
  vpc_id      = "${var.mongo_vpc_id}"
  
   #Allow inbound traffic to the mongo db servers from the VPC
  ingress {
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    cidr_blocks = ["10.9.0.0/22"]
    description = "Ingress from VPC over over mongodb port 27017"
  }

  # Allow outbound traffic from the mongo db servers to the VPC
  egress {
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    cidr_blocks = ["10.9.0.0/22"]
  }

  # Allow all HTTP traffic out, e.g. for software updates
  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Engress HTTP to ALL over port 80"
  }

  # Allow all HTTPS traffic out, e.g. for software updates
  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Engress HTTPS to ALL over port 443"
  }
  
  tags = "${merge(var.mongo_tags, map("Name", format("%s", var.mongo_app_sg_name)))}"
}

# Create a mongodb instance with preloaded setup instructions
resource "aws_instance" "mongo_db_ins" {
  #count             = "${var.mongo_count}"
  ami               = "${var.mongo_ami}"
  availability_zone = "${var.mongo_availability_zone}"
  instance_type     = "${var.mongo_instance_type}"
  subnet_id         = "${var.mongo_subnet}"
  vpc_security_group_ids = [
    "${aws_security_group.app_sg.id}"
  ]
  #key_name          = "${var.mongo_provisioning_key}"
  user_data         = "${file("${path.module}/files/user_data.sh")}"

  tags = "${merge(var.mongo_tags, map("Name", format("%s", var.mongo_name)))}"
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdh"
  volume_id   = "${var.mongo_ebs_volume}"
  instance_id = "${aws_instance.mongo_db_ins.id}"
}