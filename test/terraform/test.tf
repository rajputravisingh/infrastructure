variable "vault_addr" {
  description = "Vault server URL address"
}

variable "env_name" {
  default = "test"
}

variable "envid" {
  description = "Unique test environment identifier to prevent collisions."
}

variable "bootstrap_version" {
  default = "master"
}

variable "package" {
  default = "https://s3.eu-central-1.amazonaws.com/aeternity-node-builds/aeternity-latest-ubuntu-x86_64.tar.gz"
}

provider "aws" {
  version                 = "2.19.0"
  region                  = "ap-southeast-2"
  alias                   = "ap-southeast-2"
  shared_credentials_file = "/aws/credentials"
  profile                 = "aeternity"
}

module "aws_deploy-test" {
  source              = "github.com/aeternity/terraform-aws-aenode-deploy?ref=v2.3.1"
  env                 = "${var.env_name}"
  envid               = "${var.envid}"
  bootstrap_version   = "${var.bootstrap_version}"
  vault_role          = "ae-node"
  vault_addr          = "${var.vault_addr}"
  user_data_file      = "user_data.bash"
  node_config         = "secret/aenode/config/test"

  static_nodes = 1
  spot_nodes   = 1

  spot_price    = "0.04"
  instance_type = "t3.large"
  ami_name      = "aeternity-ubuntu-16.04-*"

  additional_storage      = true
  additional_storage_size = 5

  aeternity = {
    package = "${var.package}"
  }

  providers = {
    aws = "aws.ap-southeast-2"
  }
}
