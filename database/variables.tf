variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "db_subnet_grp" {}
