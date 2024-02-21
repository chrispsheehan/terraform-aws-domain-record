variable "root_domain_name" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "distribution" {
  type = object({
    domain_name    = string
    hosted_zone_id = string
  })
}

variable "domain_records" {
  type = list(string)
}
