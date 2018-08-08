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

module "storage_s3" {
  source = "./modules/storage/s3/"

  vpc_id = "${module.vpc_network.vpc_id}"
}

module "security_group" {
  source = "./modules/network/security_group"

  vpc_id = "${module.vpc_network.vpc_id}"
}

module "instances" {
  source = "./modules/instances/"

  aws_ami = "${var.aws_ami}"
  subnet_id = "${module.subnet_network.public_subnet_id}"
  open_security_group = "${module.security_group.open_security_group_id}"
}

resource "null_resource" "zookeeper_cluster" {

  # Make sure we can actually ssh into nodes
  provisioner "local-exec" {
    command = "sh ${path.module}/../configuration/waitforssh.sh ${module.instances.zookeeper_master_public_dns_name}"
  }

  provisioner "local-exec" {
    command = "sh ${path.module}/../configuration/waitforssh.sh ${module.instances.zookeeper_workers_public_dns_names}"
  }

  # Enables passwordless SSH from local to the MASTER and the MASTER to all the WORKERS
  provisioner "local-exec" {
    command = "configurator install ssh ${module.instances.zookeeper_master_public_dns_name} ${module.instances.zookeeper_workers_public_dns_names} ${module.instances.zookeeper_master_private_dns_name} ${module.instances.zookeeper_workers_private_dns_names}"
  }

  # Enables passwordless SSH from local to the MASTER and the MASTER to all the WORKERS
  provisioner "local-exec" {
    command = "configurator install ssh ${module.instances.zookeeper_master_public_dns_name} ${module.instances.zookeeper_workers_public_dns_names} ${module.instances.zookeeper_master_private_dns_name} ${module.instances.zookeeper_workers_private_dns_names}"
  }

  # Places AWS keys onto all machines under ~/.profile
  provisioner "local-exec" {
    command = "configurator install aws ${module.instances.zookeeper_master_public_dns_name} ${module.instances.zookeeper_workers_public_dns_names} ${module.instances.zookeeper_master_private_dns_name} ${module.instances.zookeeper_workers_private_dns_names}"
  }

  # Installs basic packages for Python, Java, etc.
  provisioner "local-exec" {
    command = "configurator install environment ${module.instances.zookeeper_master_public_dns_name} ${module.instances.zookeeper_workers_public_dns_names} ${module.instances.zookeeper_master_private_dns_name} ${module.instances.zookeeper_workers_private_dns_names}"
  }

  provisioner "local-exec" {
    command = "configurator install zookeeper ${module.instances.zookeeper_master_public_dns_name} ${module.instances.zookeeper_workers_public_dns_names} ${module.instances.zookeeper_master_private_dns_name} ${module.instances.zookeeper_workers_private_dns_names}"
  }

  provisioner "local-exec" {
    command = "configurator service start zookeeper ${module.instances.zookeeper_master_public_dns_name} ${module.instances.zookeeper_workers_public_dns_names}"
  }
}
