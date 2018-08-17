provider "aws" {
  region = "${var.aws_region}"
}

module "vpc_network" {
  source = "./modules/network/vpc/"
}

module "igw_network" {
  source = "./modules/network/igw/"
  vpc_id = "${module.vpc_network.vpc_id}"
}

module "route_table_network" {
  source = "./modules/network/route_table/"

  vpc_id = "${module.vpc_network.vpc_id}"
  igw_id = "${module.igw_network.igw_id}"
}

module "subnet_network" {
  source = "./modules/network/subnet/"

  vpc_id = "${module.vpc_network.vpc_id}"
  vpc_cidr_prefix = "${module.vpc_network.vpc_cidr_prefix}"
  aws_region = "${var.aws_region}"

  public_rt_id = "${module.route_table_network.public_rt_id}"
  private_rt_id = "${module.route_table_network.private_rt_id}"
}

module "security_group" {
  source = "./modules/network/security_group"

  vpc_id = "${module.vpc_network.vpc_id}"
}

module "instances" {
  source = "./modules/instances/"

  amis = "${var.amis}"
  aws_instance_types = "${var.aws_instance_types}"
  open_security_group = "${module.security_group.open_security_group_id}"
  pem_file_path = "${var.pem_file_path}"
  public_key_path = "${var.public_key_path}"
  public_subnet_id = "${module.subnet_network.public_subnet_id}"
  remote_download_path = "${var.remote_download_path}"
  sangrenel_flag_auto_launch_test = "${var.sangrenel_flag_auto_launch_test}"
  sangrenel_flag_message_size = "${var.sangrenel_flag_message_size}"
  sangrenel_flag_batch_size = "${var.sangrenel_flag_batch_size}"
  sangrenel_flag_num_workers = "${var.sangrenel_flag_num_workers}"
}
