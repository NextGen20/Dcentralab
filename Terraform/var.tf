
variable "ec2_instance_type" {
  default     = "t2.micro"
}

variable "rds_instance_type" {
  default     = "db.t2.micro"
}

variable "rds_allocated_storage" {
  default     = 20
}
variable "ami_id" {
  type        = string
  default = "ami-0d7a109bf30624c99"
}
variable "aws_region" {
  default     = "us-east-1"
}
variable "db_username" {
  type        = string
  sensitive   = true
}

variable "db_password" {
  type        = string
  sensitive   = true
}
