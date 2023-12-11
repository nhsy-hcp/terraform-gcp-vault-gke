module "common" {
  source = "./modules/common"

  project = var.project
  region  = var.region
}