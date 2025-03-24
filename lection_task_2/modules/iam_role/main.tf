resource "google_service_account" "iam_role" {
  account_id   = var.role_name
  display_name = "Service Account for ${var.role_name}"
}

resource "google_project_iam_binding" "assume_role" {
  count   = length(var.assume_role_members)
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${google_service_account.iam_role.email}",
    var.assume_role_members[count.index]
  ]
}

resource "google_project_iam_member" "policy_attachment" {
  for_each = toset(var.policy_roles)

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.iam_role.email}"
}

