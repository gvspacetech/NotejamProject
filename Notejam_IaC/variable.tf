variable "region" {
  default = "eu-west-2"
}
variable "AmiLinux" {
  type = "map"
  default = {

   #amzlinux#
    eu-west-2 = "ami-04122be15033aa7ec"

  }
  description = "region (London)"
}
variable "aws_access_key" {
  default = ""
  description = "the user aws access key"
}
variable "aws_secret_key" {
  default = ""
  description = "the user aws secret key"
}
variable "vpc-fullcidr" {
    default = "192.168.1.0/24"
  description = "the vpc cdir"
}
variable "Subnet-Public-AzA-CIDR" {
  default = "192.168.1.32/27"
  description = "the cidr of the subnet"
}
variable "Subnet-Private-AzA-CIDR" {
  default = "192.168.1.64/27"
  description = "the cidr of the subnet"
}
variable "Subnet-Public-AzB-CIDR" {
  default = "192.168.1.96/27"
  description = "the cidr of the subnet"
}
variable "Subnet-Private-AzB-CIDR" {
  default = "192.168.1.128/27"
  description = "the cidr of the subnet"
}
variable "Subnet-Private-AzA_2-CIDR" {
  default = "192.168.1.160/27"
  description = "the cidr of the subnet"
}
variable "Subnet-Private-AzB_2-CIDR" {
  default = "192.168.1.192/27"
  description = "the cidr of the subnet"
}
variable "key_name" {
  default = "NotejamKeyPair"
  description = "the ssh key to use in the EC2 machines"
}


variable "DnsZoneName" {
  default = "notejam.co.uk"
  description = "the internal Notejam js dns name"
}


variable "workload_variable" {
  default = "notejamworkload"
}


#rds variables

variable "skip_final_snapshot" {
  default = "true"
  //Note: set to true since this just a demo
}

variable "rds_is_multi_az" {
  default = "true"
}

variable "rds_bkup_retention_period" {
  default = 1
}

variable "rds_bkup_window" {
  default = "06:00-08:00"
}


variable "rds_allocated_storage" {
  description = "The allocated storage in GBs"
  default = 60

}

variable "rds_storage_type" {
  default = "standard"
}

variable "rds_engine_type" {
  // Valid types are
  // - mysql
  // - postgres
  // - oracle-*
  // - sqlserver-*
  // See http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
  // --engine
  default = "postgres"
}

//
variable "rds_engine_version" {
  // For valid engine versions, see:
  // See http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
  // --engine-version
  default = "10.1"
}

variable "rds_instance_class" {
  default = "db.t2.micro"
}

variable "database_name" {
  description = "The name of the database to create"
  default = ""
}

variable "database_port" {
  description = "The TCP/IP port on which the database accepts connections"
  default = 5432
}

variable "database_user" {
  default = "postgres"
}

variable "database_password" {
  default = "postgres"
}

variable "db_parameter_group" {
  default = "postgres10"
}

variable "vpc_cidr_block" {
  description = "The source CIDR block to allow traffic from"
  default = "192.168.1.0/24"
}

// Tags Variables

variable "project" {
  default = "PilotNotejam1234 - Pilot of Notejam"
}

variable "environment" {
  default = "prod"
}

variable "owner" {
  default = "vspacetech"
}

variable "email" {
 default = "vspacetech@rulebase.net"
}

variable "costcentre" {
  default = "PN1234"
}

variable "live" {
  default = "yes"
}
