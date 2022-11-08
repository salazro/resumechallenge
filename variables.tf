variable "accesskey" {
  type        = string
  description = "access key"
}

variable "secretkey" {
  type        = string
  description = "secret key"
}

variable "mykeypair" {
  type        = string
  description = "key pair name"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website"
}

variable "domain_prefix" {
  type        = string
  description = "Prefix for bucket name"

}
