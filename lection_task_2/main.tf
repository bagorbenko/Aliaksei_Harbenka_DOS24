provider "google" {
  project = "oceanic-base-450915-k4"
  region  = "europe-north1"
}

module "iam_role" {
  source             = "./modules/iam_role"
  project_id         = "oceanic-base-450915-k4"
  role_name          = "custom-iam-role"
  assume_role_members = ["user:ba.gorbenko@gmail.com"]
  policy_roles       = ["roles/reader"]
}

output "name_role" {
    value = module.iam_role.service_acc_display
}