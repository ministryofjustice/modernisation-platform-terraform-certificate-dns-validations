
variable "certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate from the certificate module"
}

variable "domain_validation_options" {
  type = set(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
  description = "Domain validation options from the certificate module"
}

variable "is-production" {
  type        = bool
  description = "Whether the environment is production or not"
}

variable "zone_id_core_vpc_public" {
  type        = string
  description = "Route53 core-vpc public hosted zone ID for certificate validation. Required for non-production deployments"
  default     = ""
}

variable "zone_id_core_network_services_public" {
  type        = string
  description = "Route53 core-network-services public hosted zone ID for certificate validation. Required for production deployments"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Common tags to be used by all resources"
}




