variable "vpcname"{
    default = "test-vpc"
}

variable "cidr" {
    default = "10.0.0.0/16"
}

variable "environment"{
    default = "dev"
}

variable "cluster-name"{
    default = "test-ekc-cluster"
}

variable "instance_type"{
    default = "t2.medium"
}

variable "testusername"{
    default = "robert"
}

variable "userpolicy" {
    default = "testuser-policy"
}