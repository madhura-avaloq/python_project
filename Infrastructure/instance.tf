
# Create a Virtual Cloud Network (VCN)
resource "oci_core_virtual_network" "vcn" {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaaygmkzd3qzze5hoxhwmextmh43e3rmnzihdopcnnqy5p3tddyqh2a" # Replace with your compartment OCID
  display_name   = "my_vcn"
  cidr_block     = "10.0.0.0/16" # Adjust the CIDR block as needed
  dns_label      = "myvcn"
}

# Create a Subnet in the VCN
resource "oci_core_subnet" "subnet" {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaaygmkzd3qzze5hoxhwmextmh43e3rmnzihdopcnnqy5p3tddyqh2a" # Use the same compartment as the VCN
  vcn_id         = oci_core_virtual_network.vcn.id                                                    # Reference the VCN ID created above
  display_name   = "my-subnet"
  cidr_block     = "10.0.1.0/24" # Adjust the CIDR block as needed
  #   availability_domain = "AP-mumbai-1-AD-1"  # Make sure this is a valid AD for your region
  dns_label = "mysubnet"
}

# Define the Internet Gateway
resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaaygmkzd3qzze5hoxhwmextmh43e3rmnzihdopcnnqy5p3tddyqh2a"  # Replace with your compartment OCID
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "internet-gateway"
  enabled     = true
}

# Define the Route Table and associate it with the Internet Gateway
resource "oci_core_route_table" "route_table" {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaaygmkzd3qzze5hoxhwmextmh43e3rmnzihdopcnnqy5p3tddyqh2a"  # Replace with your compartment OCID
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "route-table"

  route_rules {
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
    cidr_block = "0.0.0.0/0"  # Route all traffic to the Internet

  }
}

# Associate the Route Table with the Subnet

resource "oci_core_route_table_attachment" "route_table_attachment" {
  #Required    
  subnet_id = oci_core_subnet.subnet.id
  route_table_id =oci_core_route_table.route_table.id
}

# Create a new Network Security Group (NSG)
resource "oci_core_network_security_group" "nsg" {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaaygmkzd3qzze5hoxhwmextmh43e3rmnzihdopcnnqy5p3tddyqh2a"  # Replace with your compartment OCID
  display_name   = "my-nsg"
  vcn_id         = oci_core_virtual_network.vcn.id
}

# Create a Security Rule for the NSG
resource "oci_core_network_security_group_security_rule" "ssh_rule" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                = "INGRESS"
  protocol                = "6"  # TCP
  source                   = "0.0.0.0/0"  # Allow from any IP
  source_type              = "CIDR_BLOCK"
   tcp_options {
        source_port_range {
            #Required
            max =22
            min =22
        }
    }
    description = "Allow HTTP traffic"
}

# Create a Security Rule for the NSG
resource "oci_core_network_security_group_security_rule" "python_rule" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                = "INGRESS"
  protocol                = "6"  # TCP
  source                   = "0.0.0.0/0"  # Allow from any IP
  source_type              = "CIDR_BLOCK"
   tcp_options {
        source_port_range {
            #Required
            max =5000
            min =5000
        }
    }
    description = "Allow Python run on 5000 port"
}

# Create a Security Rule for the NSG
resource "oci_core_network_security_group_security_rule" "react_rule" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                = "INGRESS"
  protocol                = "6"  # TCP
  source                   = "0.0.0.0/0"  # Allow from any IP
  source_type              = "CIDR_BLOCK"
   tcp_options {
        source_port_range {
            #Required
            max =3000
            min =3000
        }
    }
    
}

# Create a Security Rule for the NSG
resource "oci_core_network_security_group_security_rule" "http_rule" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                = "INGRESS"
  protocol                = "6"  # TCP
  source                   = "0.0.0.0/0"  # Allow from any IP
  source_type              = "CIDR_BLOCK"
   tcp_options {
        source_port_range {
            #Required
            max =80
            min =80
        }
    }
    
}

# Add an EGRESS rule to allow all outbound traffic
resource "oci_core_network_security_group_security_rule" "egress_rule" {
  network_security_group_id = oci_core_network_security_group.nsg.id
  direction                = "EGRESS"
  protocol                = "all"  # All protocols
  destination              = "0.0.0.0/0"  # Allow to any IP
  destination_type         = "CIDR_BLOCK"
  description             = "Allow all outbound traffic"
}

resource "oci_core_instance" "test_instance" {
  #Required
  availability_domain = "ORSi:AP-MUMBAI-1-AD-1"
  compartment_id      = "ocid1.compartment.oc1..aaaaaaaaygmkzd3qzze5hoxhwmextmh43e3rmnzihdopcnnqy5p3tddyqh2a"
  shape               = "VM.Standard.E2.1"
  create_vnic_details {
    subnet_id     = oci_core_subnet.subnet.id
    nsg_ids =       [oci_core_network_security_group.nsg.id]
  }                 
  display_name = "my_instance"
  source_details {
    source_id   = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaas36pyk6rlwikddubsplrbbfpjqz3xdrfv76i73434upzxnfq3vpq"
    source_type = "image"
  }

   metadata = {
    ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQ6bptAIZNzPMTirqCfQ++MuFEXq9cOXy4j3HJyYhfYg4fhKF14O03QbFBTYmvRJPL+yfLBdWZp/B9RJow9g9Z/o0BEOcN32+L79nSm0/KRtT32M51oSxiFkS+pHCm+sUQEtbnpq8Tj0Y9uFYc+mALruHFXw/NVCyWROLwKhrQi/HQnb1fgiQRviZBdM0aCusqTOxyny5PPO4OWLPv8H4u1VTS8Fj6yA0unjJzMT6sl4u4eXVtpFdlMnnFTgAMjBSulxVid+FFU7qIO/6wlIk5kT7yrfWxXM3mMD1PKXQZEhHOJBqocXioVXwxFG5F6zVWkFfpd9DpV2UdrzZWxwWh/QcliVVwEY+VsWNAlQJMd1lXcM8VdjtO5MpbXP5cNm174CpvC9SXApGDfbL7OEH/8zq7HpwDICeojsp3SGhRTqZF+cxy7JMIBOfDO0zo23ach6Gg45Hj7KvPN23wDgocXZrwAZs1dDueL1QxZC1IccPuEZ8f7FURr/m8deWh88k= sys\u006448@WCLINB110039"


  }

}
