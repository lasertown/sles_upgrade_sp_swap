module "rg0" {
  source = "./modules/resource_group"
  rg = "sles_upgrade_swap"
}
  
module "network0" {
  source = "./modules/network"
  rg = module.rg0.rg
  region = "westus2"
  address_space = [ "10.0.0.0/16" ]
  address_prefixes = [ "10.0.0.0/24" ]
}

module "storage_account0" {
  source = "./modules/storage_account"
  rg = module.rg0.rg
  region = module.network0.region
}
  
module "NSG0" {
  source = "./modules/NSG"
  rg = module.rg0.rg
  region = module.network0.region
  subnet = module.network0.subnet
}
      
module "node0" {
  source = "./modules/node"
  rg = module.rg0.rg
  region = module.network0.region
  subnet = module.network0.subnet
  NSGid = module.NSG0.NSGid
  console = module.storage_account0.console
  size = "Standard_B2ms"
  publisher = "SUSE"
  offer = "sles-sap-15-sp1"
  sku = "gen2"
  _version = "latest"
  tag = "node0"
}

module "node1" {
  source = "./modules/node"
  rg = module.rg0.rg
  region = module.network0.region
  subnet = module.network0.subnet
  NSGid = module.NSG0.NSGid
  console = module.storage_account0.console
  size = "Standard_B2ms"
  publisher = "SUSE"
  offer = "sles-sap-15-sp1"
  sku = "gen2"
  _version = "latest"
  tag = "node1"
}
