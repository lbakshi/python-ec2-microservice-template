variable project_name {
    type = string
    default = "template"
    description = "The name of the project"
}

variable instance_type {
    type = string
    default = "t2.micro"
    description = "The type of instance to use"
}

variable ami_id {
    type = string
    default = "ami-0f1a5f5ada0e7da53"
    description = "The AMI ID for the region you're using"
}

variable instance_key {
    type = string
    default = "template-test-key"
    description = "The SSH key name to use for the instance"
}

variable region {
    type = string
    default = "us-west-2"
    description = "The region to use"
}

variable key_pair_pem_file {
    type = string
    default = "template-test-key.pem"
    description = "decoded key pair pub file name"
}