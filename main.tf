provider "oci" {
  tenancy_ocid          = var.tenancy_ocid
  user_ocid             = var.user_ocid
  fingerprint           = var.oracle_api_key_fingerprint
  private_key_path      = var.oracle_api_private_key_path
#  private_key_password  = var.oracle_api_private_key_password
  region                = var.region
}

resource "oci_core_vcn" "zurek_vcn" {
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_ocid
  display_name   = "zurekVCN"
  dns_label      = "zurekVCN"
}

resource "oci_core_subnet" "zurek_subnet" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "10.1.0.0/24"
  display_name        = "zurekSubnet"
  dns_label           = "zurekSubnet"
  security_list_ids   = [oci_core_security_list.zurek_security_list.id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.zurek_vcn.id
  route_table_id      = oci_core_vcn.zurek_vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.zurek_vcn.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "zurek_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "zurek_IG"
  vcn_id         = oci_core_vcn.zurek_vcn.id
}

resource "oci_core_default_route_table" "test_route_table" {
  manage_default_resource_id = oci_core_vcn.zurek_vcn.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.zurek_internet_gateway.id
  }
}

resource "oci_core_security_list" "zurek_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.zurek_vcn.id
  display_name   = "zurek Security List"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  // allow inbound ssh traffic from a all ports to port
  # ingress_security_rules {
  #   protocol  = "6" // tcp
  #   source    = "0.0.0.0/0"
  #   stateless = false

  #   tcp_options {
  #     source_port_range {
  #       min = 1
  #       max = 65535
  #     }

  #     // These values correspond to the destination port range.
  #     min = 22
  #     max = 22
  #   }
  # }

  // allow inbound ssh traffic from a all ports to port
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      source_port_range {
        min = 1
        max = 65535
      }

      // These values correspond to the destination port range.
      min = 818
      max = 818
    }
  }

  // allow inbound http traffic from a all ports to port
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      source_port_range {
        min = 1
        max = 65535
      }

      // These values correspond to the destination port range.
      min = 80
      max = 80
    }
  }

  // allow inbound https traffic from a all ports to port
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      source_port_range {
        min = 1
        max = 65535
      }

      // These values correspond to the destination port range.
      min = 443
      max = 443
    }
  }

  // allow inbound https traffic from a all ports to port
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      source_port_range {
        min = 1
        max = 65535
      }

      // These values correspond to the destination port range.
      min = 8080
      max = 8080
    }
  }

  // allow inbound https traffic from a all ports to port
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      source_port_range {
        min = 1
        max = 65535
      }

      // These values correspond to the destination port range.
      min = 8081
      max = 8081
    }
  }

  // allow inbound https traffic from a all ports to port
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      source_port_range {
        min = 1
        max = 65535
      }

      // These values correspond to the destination port range.
      min = 8083
      max = 8083
    }
  }

  // allow inbound udp traffic from all ports to 51820
  ingress_security_rules {
    protocol  = "17" // udp
    source    = "0.0.0.0/0"
    stateless = false

    udp_options {
      source_port_range {
        min = 1
        max = 65535
      }

      // These values correspond to the destination port range.
      min = 3478
      max = 3478
    }
  }

  // allow inbound udp traffic from all ports to 51820
  ingress_security_rules {
    protocol  = "17" // udp
    source    = "0.0.0.0/0"
    stateless = false

    udp_options {
      source_port_range {
        min = 1
        max = 65535
      }

      // These values correspond to the destination port range.
      min = 49152
      max = 65535
    }
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    description = "icmp_inbound"
    protocol    = 1
    source      = "0.0.0.0/0"
    stateless   = false

    icmp_options {
      type = 3
      code = 4
    }
  }
}

resource "oci_core_instance" "zurek_instance" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_display_name
  shape               = var.instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.zurek_subnet.id
    display_name     = "zurekVNIC"
    assign_public_ip = true
    hostname_label   = var.instance_display_name
  }

  shape_config {
    #Optional
    memory_in_gbs = var.instance_shape_config_memory_in_gbs
    ocpus = var.instance_shape_config_ocpus
  }

  
  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid[var.region]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(file("./userdata/init.sh"))
  }

  timeouts {
    create = "60m"
  }
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.compartment_ocid
  ad_number      = var.availability_domain_number
}

# Gets a list of vNIC attachments on the instance
data "oci_core_vnic_attachments" "instance_vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domain.ad.name
  instance_id         = oci_core_instance.zurek_instance.id
}

# Gets the OCID of the first (default) vNIC
data "oci_core_vnic" "instance_vnic" {
  vnic_id = lookup(data.oci_core_vnic_attachments.instance_vnics.vnic_attachments[0], "vnic_id")
}

provider "cloudflare" {
  api_token = "5ofQJueFTxjYS1M82hASZ6Lxx9NXGM_YkSF5dVKy"
}

resource "cloudflare_record" "oracle_zurek_top" {
  zone_id = "cc652262a61cb416da93a33ff59c9f9d"
  name    = "oracle.zurek.top"
  value   = "${oci_core_instance.zurek_instance.public_ip}"
  type    = "A"
  proxied = false
  allow_overwrite = true
}

resource "cloudflare_record" "wildcard_oracle_zurek_top" {
  zone_id = "cc652262a61cb416da93a33ff59c9f9d"
  name    = "*.oracle.zurek.top"
  value   = "${oci_core_instance.zurek_instance.public_ip}"
  type    = "A"
  proxied = false
  allow_overwrite = true
}


resource "cloudflare_record" "zurek_top" {
  zone_id = "cc652262a61cb416da93a33ff59c9f9d"
  name    = "zurek.top"
  value   = "${oci_core_instance.zurek_instance.public_ip}"
  type    = "A"
  proxied = false
  allow_overwrite = true
}
resource "cloudflare_record" "wildcard_zurek_top" {
  zone_id = "cc652262a61cb416da93a33ff59c9f9d"
  name    = "*.zurek.top"
  value   = "${oci_core_instance.zurek_instance.public_ip}"
  type    = "A"
  proxied = false
  allow_overwrite = true
}
# resource "oci_core_instance_console_connection" "zurek_instance_console_connection" {
#   #Required
#   instance_id = oci_core_instance.zurek_instance.id
#   public_key  = var.ssh_public_key
# }

# output "connect_with_ssh" {
#   value = oci_core_instance_console_connection.zurek_instance_console_connection.connection_string
# }

# output "connect_with_vnc" {
#   value = oci_core_instance_console_connection.zurek_instance_console_connection.vnc_connection_string
# }


# resource "null_resource" "cloud_init_watcher_provisioner" {
#   triggers = {
#     state = "RUNNING"
#   }

#   connection {
#     type        = "ssh"
#     host        = oci_core_instance.zurek_instance.public_ip
#     user        = "ubuntu"
#     port        = "22"
#     private_key = file(var.ssh_private_key_path)
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "tail -f /var/log/cloud-init-output.log",
#     ]
#   }

#   provisioner "local-exec" {
#     # this will SSH into the newly created instance and tail the init log from our script
#     command = "ssh -o 'StrictHostKeyChecking no' -o 'ConnectionAttempts 1000' -i ${var.ssh_private_key_path} ubuntu@${oci_core_instance.zurek_instance.public_ip} tail -f /var/log/cloud-init-output.log"
#   }

# }
