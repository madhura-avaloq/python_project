# Virtual Cloud Network (VCN)
resource "oci_core_virtual_network" "vcn" {
  compartment_id = var.compartment_id
  display_name   = "app-vcn"
  cidr_block     = "10.0.0.0/16" 
  dns_label      = "myvcn"
}

# Subnet in the VCN
resource "oci_core_subnet" "subnet" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id                                                    
  display_name   = "app-subnet"
  cidr_block     = "10.0.1.0/24" 
  dns_label = "mysubnet"
}

# Internet Gateway
resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id =  var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "app-internet-gateway"
  enabled     = true
}

# Route Table and associate it with the Internet Gateway
resource "oci_core_route_table" "route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "app-route-table"

  route_rules {
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
    cidr_block = "0.0.0.0/0"  

  }
}

# Route Table with the Subnet
resource "oci_core_route_table_attachment" "route_table_attachment" { 
  subnet_id = oci_core_subnet.subnet.id
  route_table_id =oci_core_route_table.route_table.id
}

# Network Security Group (NSG)
resource "oci_core_network_security_group" "nsg" {
  compartment_id = var.compartment_id
  display_name   = "app-nsg"
  vcn_id         = oci_core_virtual_network.vcn.id
}

# Security Rule for the NSG
resource "oci_core_network_security_group_security_rule" "ssh_rule" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                = "INGRESS"
  protocol                = "6"  
  source                   = "0.0.0.0/0"  
  source_type              = "CIDR_BLOCK"
   tcp_options {
        source_port_range {
            max =22
            min =22
        }
    }
    description = "Allow HTTP traffic"
}

# Security Rule for the NSG
resource "oci_core_network_security_group_security_rule" "python_rule" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                = "INGRESS"
  protocol                = "6"  
  source                   = "0.0.0.0/0"  
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
resource "oci_core_network_security_group_security_rule" "react_rule" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                = "INGRESS"
  protocol                = "6"  
  source                   = "0.0.0.0/0"  
  source_type              = "CIDR_BLOCK"
   tcp_options {
        source_port_range {
            max =3000
            min =3000
        }
    }
    description = "Allow React run on 3000 port"
}

# Security Rule for the NSG
resource "oci_core_network_security_group_security_rule" "http_rule" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                = "INGRESS"
  protocol                = "6" 
  source                   = "0.0.0.0/0"  
  source_type              = "CIDR_BLOCK"
   tcp_options {
        source_port_range {
            max =80
            min =80
        }
    }
}

# EGRESS rule to allow all outbound traffic
resource "oci_core_network_security_group_security_rule" "egress_rule" {
  network_security_group_id = oci_core_network_security_group.app_nsg.id
  direction                = "EGRESS"
  protocol                = "all"  
  destination              = "0.0.0.0/0"  
  destination_type         = "CIDR_BLOCK"
  description             = "Allow all outbound traffic"
}