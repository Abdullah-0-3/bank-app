module "security_group" {
  source = "./modules/security_group"

  security_group_name = local.security_group_name
  tags                = local.tags
}

module "instance" {
  source = "./modules/instance"

  tags                = local.tags
  key_name            = local.key_name
  instance_type       = local.instance_type
  security_group_name = module.security_group.security_group_name
}