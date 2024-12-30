variable "compartment_id"{
    description = "ID for compartment"
    type = string
}

variable "source_id"{
    description = "image source ID for instance"
    type = string
}


variable "ssh_key"{
    description = "authorized key for instance"
    type = string
}

variable "availability_domain"{
    description = "availability_domain"
    type = string
}