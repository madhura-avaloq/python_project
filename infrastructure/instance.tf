resource "oci_core_instance" "test_instance" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  shape               = "VM.Standard.A1.Flex"
  create_vnic_details {
    subnet_id     = oci_core_subnet.subnet.id
    nsg_ids =       [oci_core_network_security_group.nsg.id]
  }
  display_name = "app_instance"
 
shape_config{
 ocpus = 2
 memory_in_gbs = 16

  }

  source_details {
    source_id   = var.source_id
    source_type = "image"
  }

   metadata = {
    ssh_authorized_keys = var.ssh_key
    user_data = base64encode(file("${path.module}/cloud_init.sh"))
  }

}
