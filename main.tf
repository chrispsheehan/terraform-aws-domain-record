resource "aws_route53_record" "app" {
  count   = length(var.domain_records)
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_records[count.index]
  type    = "A"
  alias {
    name                   = var.distribution.domain_name
    zone_id                = var.distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"
}

# validate cert:
resource "aws_route53_record" "certvalidation" {
  for_each = {
    for d in aws_acm_certificate.cert.domain_validation_options : d.domain_name => {
      name   = d.resource_record_name
      record = d.resource_record_value
      type   = d.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}

resource "aws_acm_certificate_validation" "certvalidation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for r in aws_route53_record.certvalidation : r.fqdn]
}
