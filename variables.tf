variable "project_name"{
 
}

variable "environment"{
 
}


variable "cidr_block"{
 
}

variable "enable_dns_hostnames"{
    default = true
 
}

variable "common_tags"{
    default = {}
}
variable "vpc_tags"{
    default = {}
}

variable "igw_tags"{
    default={}

}

variable "public_subnet_cidrs"{
    validation{
        condition = length(var.public_subnet_cidrs)==2
        error_message = "please provide 2 public_subnet_cidrs"
    }
}
variable "private_subnet_cidrs"{
    validation{
        condition = length(var.private_subnet_cidrs)==2
        error_message = "please provide 2 private_subnet_cidrs"
    }
}
variable "database_subnet_cidrs"{
    validation{
        condition = length(var.database_subnet_cidrs)==2
        error_message = "please provide 2 database_subnet_cidrs"
    }
}

variable "public_subnet_tags"{
 default={}
}
variable "private_subnet_tags"{
 default={}
}
variable "database_subnet_tags"{
 default={}
}

variable "subnet_group_tags"{
 default={}
}

variable "NAT_tags"{
 default={}
}