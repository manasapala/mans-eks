variable "cluster_name" {
  default = "example-cluster"
  type    = string
}
variable "accessing_computer_ip" {
  type        = string
  description = "Public IP of the computer accessing the cluster via kubectl or browser."
  default     = "67.169.175.185"
}

variable "aws_region" {
  type        = string
  description = "The region in which the cluster needs to be provided"
  default     = "us-east-2"
}

#variable "keypair-name" {
#  type    = string
#  default = "mans-eks-key"
#}

#variable "app_subnet_ids" {
#  type    = list
#  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#  default = ["10.0.10.0/24", "10.0.20.0/24"]
#}

variable "cluster_version" {
  type    = string
  default = "1.18"
}
variable "subnet_count" {
  type    = number
  default = 3
}
