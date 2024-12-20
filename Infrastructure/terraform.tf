variable "compartment_id"{
    description = "ID for compartment"
    type = string
    default = "ocid1.compartment.oc1..aaaaaaaaygmkzd3qzze5hoxhwmextmh43e3rmnzihdopcnnqy5p3tddyqh2a"
}

variable "source_id"{
    description = "image source ID for instance"
    type = string
    default = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaas36pyk6rlwikddubsplrbbfpjqz3xdrfv76i73434upzxnfq3vpq"
}


variable "ssh_key"{
    description = "authorized key for instance"
    type = string
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDQ6bptAIZNzPMTirqCfQ++MuFEXq9cOXy4j3HJyYhfYg4fhKF14O03QbFBTYmvRJPL+yfLBdWZp/B9RJow9g9Z/o0BEOcN32+L79nSm0/KRtT32M51oSxiFkS+pHCm+sUQEtbnpq8Tj0Y9uFYc+mALruHFXw/NVCyWROLwKhrQi/HQnb1fgiQRviZBdM0aCusqTOxyny5PPO4OWLPv8H4u1VTS8Fj6yA0unjJzMT6sl4u4eXVtpFdlMnnFTgAMjBSulxVid+FFU7qIO/6wlIk5kT7yrfWxXM3mMD1PKXQZEhHOJBqocXioVXwxFG5F6zVWkFfpd9DpV2UdrzZWxwWh/QcliVVwEY+VsWNAlQJMd1lXcM8VdjtO5MpbXP5cNm174CpvC9SXApGDfbL7OEH/8zq7HpwDICeojsp3SGhRTqZF+cxy7JMIBOfDO0zo23ach6Gg45Hj7KvPN23wDgocXZrwAZs1dDueL1QxZC1IccPuEZ8f7FURr/m8deWh88k= sys\u006448@WCLINB110039"
}