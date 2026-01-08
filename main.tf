
resource "aws_route53_record" "dns_validation_record_core_vpc" {
  for_each = var.is-production ? {} : {
    for dvo in var.domain_validation_options : dvo.resource_record_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  
  provider = aws.core-vpc
  zone_id  = var.zone_id_core_vpc_public
  name     = each.value.name
  type     = each.value.type
  records  = [each.value.record]
  ttl      = 300
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dns_validation_record_core_network_services" {
  for_each = var.is-production ? {
    for dvo in var.domain_validation_options : dvo.resource_record_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}
  
  provider = aws.core-network-services
  zone_id  = var.zone_id_core_network_services_public
  name     = each.value.name
  type     = each.value.type
  records  = [each.value.record]
  ttl      = 300
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "prod" {
  count                   = var.is-production ? 1 : 0
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = [for record in aws_route53_record.dns_validation_record_core_network_services : record.fqdn]
}

resource "aws_acm_certificate_validation" "non_prod" {
  count                   = var.is-production ? 0 : 1
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = [for record in aws_route53_record.dns_validation_record_core_vpc : record.fqdn]
}
