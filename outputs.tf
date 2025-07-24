output "oracle_instance_id" {
  description = "ocid of created instances. "
  value       = ["${oci_core_instance.instance.id}"]
}

output "oracle_private_ip" {
  description = "Private IPs of created instances. "
  value       = ["${oci_core_instance.instance.private_ip}"]
}

output "oracle_public_ip" {
  description = "Public IPs of created instances. "
  value       = ["${oci_core_instance.instance.public_ip}"]
}

output "oracle_cloudflare_domain" {
  description = "Domain assigned to oracle instance"
  value       = ["${cloudflare_dns_record.oracle.name}"]
}