
# Virtual Cloud Network (VCN)
resource "oci_core_virtual_network" "app_vcn" {
  compartment_id = var.compartment_id
  display_name   = "app-vcn"
  cidr_block     = "10.0.0.0/16" 
  dns_label      = "myvcn"
}

#  Subnet
resource "oci_core_subnet" "app_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.app_vcn.id                                                   
  display_name   = "app-subnet"
  cidr_block     = "10.0.1.0/24" 
  dns_label = "mysubnet"
}

#Internet Gateway
resource "oci_core_internet_gateway" "app_internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.app_vcn.id
  display_name   = "app-internet-gateway"
  enabled     = true
}

# Route Table 
resource "oci_core_route_table" "route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.app_vcn.id
  display_name   = "route-table"

  route_rules {
    network_entity_id = oci_core_internet_gateway.app_internet_gateway.id
    cidr_block = "0.0.0.0/0"  

  }
}

# Associate the Route Table with the Subnet

resource "oci_core_route_table_attachment" "route_table_attachment" {
     
  subnet_id = oci_core_subnet.app_subnet.id
  route_table_id =oci_core_route_table.route_table.id
}

# Network Security Group (NSG)
resource "oci_core_network_security_group" "app_nsg" {
  compartment_id = var.compartment_id
  display_name   = "app-nsg"
  vcn_id         = oci_core_virtual_network.app_vcn.id
}

# Security Rule for the NSG
resource "oci_core_network_security_group_security_rule" "ssh_rule" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                = "INGRESS"
  protocol                = "6"  # TCP
  source                   = "0.0.0.0/0"  # Allow from any IP
  source_type              = "CIDR_BLOCK"
   tcp_options {
        source_port_range {
        
            max =22
            min =22
        }
    }
    description = "Allow HTTP traffic"
}

#Security Rule for the NSG
resource "oci_core_network_security_group_security_rule" "backend_rule" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                = "INGRESS"
  protocol                = "6"  # TCP
  source                   = "0.0.0.0/0"  # Allow from any IP
  source_type              = "CIDR_BLOCK"
   tcp_options {
        source_port_range {
            
            max =5000
            min =5000
        }
    }
    description = "Allow Python run on 5000 port"
}

# Security Rule for the NSG
resource "oci_core_network_security_group_security_rule" "frontend_rule" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                = "INGRESS"
  protocol                = "6"  # TCP
  source                   = "0.0.0.0/0"  # Allow from any IP
  source_type              = "CIDR_BLOCK"
   tcp_options {
        source_port_range {
          
            max =3000
            min =3000
        }
    }
    
}

# Security Rule for the NSG
resource "oci_core_network_security_group_security_rule" "http_rule" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                = "INGRESS"
  protocol                = "6"  # TCP
  source                   = "0.0.0.0/0"  # Allow from any IP
  source_type              = "CIDR_BLOCK"
   tcp_options {
        source_port_range {
            
            max =80
            min =80
        }
    }
    
}

# EGRESS rule 
resource "oci_core_network_security_group_security_rule" "egress_rule" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                = "EGRESS"
  protocol                = "all"  # All protocols
  destination              = "0.0.0.0/0"  # Allow to any IP
  destination_type         = "CIDR_BLOCK"
  description             = "Allow all outbound traffic"
}

resource "oci_core_instance" "test_instance" {
  
  availability_domain = "ORSi:AP-MUMBAI-1-AD-1"
  compartment_id      = var.compartment_id
  shape               = "VM.Standard.E2.1"
  create_vnic_details {
    subnet_id     = oci_core_subnet.app_subnet.id
    nsg_ids =       [oci_core_network_security_group.app_nsg.id]
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