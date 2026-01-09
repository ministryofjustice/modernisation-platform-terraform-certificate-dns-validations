# Mock certificate for testing
resource "aws_acm_certificate" "test_certificate" {
  domain_name       = "platforms-test.modernisation-platform.service.justice.gov.uk"
  validation_method = "DNS"
  subject_alternative_names = ["testing.platforms-test.modernisation-platform.service.justice.gov.uk", "*.testing.platforms-test.modernisation-platform.service.justice.gov.uk"]
  lifecycle {
    create_before_destroy = true
  }
  tags = local.tags
}

module "module_test" {
  source = "../../"

  certificate_arn                          = aws_acm_certificate.test_certificate.arn
  domain_validation_options                = aws_acm_certificate.test_certificate.domain_validation_options
  is-production                            = local.is-production
  zone_id_core_vpc_public                  = aws_route53_zone.external.zone_id
  tags                                     = local.tags

  providers = {
    aws.core-vpc              = aws.core-vpc
    aws.core-network-services = aws.core-network-services
  }
}
