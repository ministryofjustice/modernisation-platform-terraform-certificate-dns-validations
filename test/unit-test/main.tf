# Create certificate for testing
resource "aws_acm_certificate" "test_certificate" {
  domain_name               = "platforms-test.modernisation-platform.service.justice.gov.uk"
  validation_method         = "DNS"
  subject_alternative_names = ["*.testing.platforms-test.modernisation-platform.service.justice.gov.uk"]
  lifecycle {
    create_before_destroy = true
  }
  tags = local.tags
}

# Mock domain validation options for testing (to avoid "known after apply" issue)
locals {
  mock_domain_validation_options = toset([
    {
      domain_name           = "platforms-test.modernisation-platform.service.justice.gov.uk"
      resource_record_name  = "_test1.platforms-test.modernisation-platform.service.justice.gov.uk"
      resource_record_type  = "CNAME"
      resource_record_value = "_test1.acm-validations.aws."
    },
    {
      domain_name           = "*.testing.platforms-test.modernisation-platform.service.justice.gov.uk"
      resource_record_name  = "_test2.platforms-test.modernisation-platform.service.justice.gov.uk"
      resource_record_type  = "CNAME"
      resource_record_value = "_test2.acm-validations.aws."
    }
  ])
}

module "module_test" {
  source = "../../"

  certificate_arn                      = aws_acm_certificate.test_certificate.arn
  domain_validation_options            = local.mock_domain_validation_options
  enable_certificate_validation        = false
  is-production                        = local.is-production
  zone_id_core_vpc_public              = data.aws_route53_zone.external.zone_id
  zone_id_core_network_services_public = data.aws_route53_zone.network-services.zone_id
  tags                                 = local.tags

  providers = {
    aws.core-vpc              = aws.core-vpc
    aws.core-network-services = aws.core-network-services
  }
}
