variable "oracle_oci_api_key_fingerprint" {}
variable "oracle_oci_api_private_key_path" {}
variable "oracle_oci_compartment_ocid" {}
variable "oracle_oci_tenancy_ocid" {}
variable "oracle_oci_user_ocid" {}
variable "oracle_oci_region" {}
variable "oracle_oci_instance_display_name" {}
variable "oracle_oci_vcn_cidr_block" {
  default = "10.1.0.0/16"
}
variable "oracle_oci_availability_domain_number" {
  #Note: Free-Tier is confined to availability domain 1.  There is no constraint on the Flex Tier
  default = 1
}
variable "oracle_oci_instance_shape" {
  # Free-Tier is VM.Standard.E2.1.Micro
  # Flex-Tier (Free) is VM.Standard.A1.Flex
#   default = "VM.Standard.A1.Flex"
   default = "VM.Standard.E2.1.Micro"
}
variable "oracle_oci_instance_shape_config_memory_in_gbs" {
  default = "1"
}
variable "oracle_oci_instance_shape_config_ocpus" {
  default = "1"
}

variable "oracle_oci_oracle_api_private_key_password" {
	default = ""
}
variable "oracle_oci_instance_image_ocid" {
  type = map
}
variable "oracle_oci_ssh_public_key" {}
variable "oracle_oci_ssh_private_key_path" {}
