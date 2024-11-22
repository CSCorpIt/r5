terraform {
  backend "azurerm" {
    key                  = "snackingnextgen-dev-comp-eastus2.tfstate"
    resource_group_name  = "ODDA-TFSTATE-DEV-RG"
    storage_account_name = "oddatfstateeus2devsa"
    container_name       = "resource-tfstate"
  }
}


//IF IT IS FOR LOCAL USE ONLY WHAT IS PURPOSE OF THE BLOCK?
//The step - name: terraform init put all the modules in the same context by copying /.github/templates/aks/ to this working dir

locals {
  solution_name       = r5
  region              = r5
  environment         = replace_environment
  vnet_name           = replace_vnet_name
  vnet_rg             = replace_vnet_rg
  resource_group_name = replace_rg_name
}


module "kubernetes" {
  // Clonning module over HTTPS.
  source                        = "git@github.com/Mars-DNA/DNA-Central-Deployment.git//_modules/kubernetes-cluster?ref=main"
  tags                          = module.solution_settings.tags
  solution_settings             = module.solution_settings.settings
  providers = {
    azurerm.remote = azurerm.remote
  }
  depends_on = [
    azurerm_resource_group.kubernetes
  ]
}
