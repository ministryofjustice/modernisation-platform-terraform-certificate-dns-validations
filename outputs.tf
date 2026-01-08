output "certificate_validation_id" {
  description = "The ID of the certificate validation resource"
  value       = var.is-production ? try(aws_acm_certificate_validation.prod[0].id, null) : try(aws_acm_certificate_validation.non_prod[0].id, null)
}

output "validation_record_fqdns" {
  description = "The FQDNs of the validation records created"
  value       = var.is-production ? [for record in aws_route53_record.dns_validation_record_core_network_services : record.fqdn] : [for record in aws_route53_record.dns_validation_record_core_vpc : record.fqdn]
}
