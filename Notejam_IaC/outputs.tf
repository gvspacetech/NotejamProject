// Output the ID of the RDS instance

output "rds_instance_id" {
  value = "${aws_db_instance.main_rds_instance.id}"
}

// Output the Address of the RDS instance
output "rds_instance_address" {
  value = "${aws_db_instance.main_rds_instance.address}"
}

// Output the Port of the RDS instance
output "rds_instance_port" {
  value = "${aws_db_instance.main_rds_instance.port}"
}

// Output the ID of the Subnet Group
output "subnet_group_id" {
  value = "${aws_db_subnet_group.main_db_subnet_group.id}"
}

//note: all other outputs ignored since this is just a demo


