variable "compartment_id"{
    description = "ID for compartment"
    type = string
    default = "ocid1.compartment.oc1..aaaaaaaamnkhag7vc54f5apff3bfbrcqbckgpxobkdi5qda5nemgumixkfsa"
}

variable "source_id"{
    description = "image source ID for instance"
    type = string
    default = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaas36pyk6rlwikddubsplrbbfpjqz3xdrfv76i73434upzxnfq3vpq"
}


variable "ssh_key"{
    description = "authorized key for instance"
    type = string
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+oHr6jG5IuG/WLlZDtCfEbyly6vd0xOcN6Q9mfJtyRZljX7K7F1giKEpKlLRm5Rc2H/lvzSCt+/ZWHs/i8vnl0D2uqqRliaruRWlSvZmGrs0yPEeR9ZfKRii4aEFWgLJ14MlAsW7KN13jzvP0N+ghiPySSJQ10WdAsBeYpEHbRTfI9+vZET+3w4ZXeunGdppxLttIGhq8KxhDkgi5AtBQB8P/bJ0qlJ2k7l7jmqbxah0LJ41WJcvhAJANrn62CWDBl3v5zufCeG6eTanBuzzdIwd7cEvHqPBpxloIeam0onBvtC/K4i55xZby5Bdj7CdlcDyp+HqhlmzYUmqpDEf6gOkJ54uQAp99d82xlacFNHKYU/E4x7Klbbbzx+KjEPLgnKuXxIl1Qmj4egvFtrY/qc9bo8QlXmv+DCugFBkqERKin4NqtY8B32aJifL0Bpvlibw5Fa++FA0TwvRO9mhAhNPMy4EAo+/c2hLz+appeHlBbGsrzLyu2bRXl7Nkrtk= sys\u006449@WCLINB110033"
}