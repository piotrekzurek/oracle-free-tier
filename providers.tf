provider "oci" {
  tenancy_ocid          = var.oracle_oci_tenancy_ocid
  user_ocid             = var.oracle_oci_user_ocid
  fingerprint           = var.oracle_oci_api_key_fingerprint
  private_key_path      = var.oracle_oci_api_private_key_path
  region                = var.oracle_oci_region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# provider "google" {
#   project = var.googke_gcp_project_id
#   region  = var.google_gcp_region
# }
