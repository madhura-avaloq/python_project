
resource "oci_core_instance" "test_instance" {
  availability_domain = "ORSi:AP-MUMBAI-1-AD-1"
  compartment_id      = var.compartment_id
  shape               = "VM.Standard.E2.1"
  create_vnic_details {
    subnet_id     = oci_core_subnet.subnet.id
    nsg_ids =       [oci_core_network_security_group.nsg.id]
  }                 
  display_name = "app_instance"
  source_details {
    source_id   = var.source_id
    source_type = "image"
  }

   metadata = {
    ssh_authorized_keys = var.ssh_key

  }

}
