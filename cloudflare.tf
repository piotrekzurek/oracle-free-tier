resource "cloudflare_dns_record" "top_domain" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "${var.cloudflare_domain_name}"
  content   = "${oci_core_instance.instance.public_ip}"
  type    = "A"
  proxied = false
  ttl = 1
}

resource "cloudflare_dns_record" "oracle" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "${var.oracle_oci_instance_display_name}.${var.cloudflare_domain_name}"
  content   = "${oci_core_instance.instance.public_ip}"
  type    = "A"
  proxied = false
  ttl = 1

}

resource "cloudflare_dns_record" "wildcard_oracle" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "*.${var.oracle_oci_instance_display_name}.${var.cloudflare_domain_name}"
  content   = "${oci_core_instance.instance.public_ip}"
  type    = "A"
  proxied = false
  ttl = 1
}

resource "null_resource" "saved_cloudflare_dns_records" {
  depends_on = [
    cloudflare_dns_record.top_domain,
    cloudflare_dns_record.oracle,
    cloudflare_dns_record.wildcard_oracle
  ]

  triggers = {
    top_domain = cloudflare_dns_record.top_domain.content
    oracle = cloudflare_dns_record.oracle.content
    wildcard_oracle = cloudflare_dns_record.wildcard_oracle.content
    top_domain_ttl = cloudflare_dns_record.top_domain.ttl
    oracle_ttl = cloudflare_dns_record.oracle.ttl
    wildcard_oracle_ttl = cloudflare_dns_record.wildcard_oracle.ttl
  }

  provisioner "local-exec" {
    command = "curl -s -X GET \"https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/export\" -H \"Authorization: Bearer $API_TOKEN\" > cloudflare_dns_records.txt"
    
    environment = {
      ZONE_ID = var.cloudflare_zone_id
      API_TOKEN = var.cloudflare_api_token
    }
  }
}

data "http" "cloudflare_dns_export" {
  url = "https://api.cloudflare.com/client/v4/zones/${var.cloudflare_zone_id}/dns_records"
  
  request_headers = {
    Authorization = "Bearer ${var.cloudflare_api_token}"
  }
  
  depends_on = [
    cloudflare_dns_record.top_domain,
    cloudflare_dns_record.oracle,
    cloudflare_dns_record.wildcard_oracle
  ]
}

resource "local_file" "cloudflare_dns_records" {
  content  = data.http.cloudflare_dns_export.response_body
  filename = "cloudflare_dns_records.json"
}