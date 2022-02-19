resource "aws_acm_certificate" "default" {
  provider = aws
  domain_name = "${var.domain}"
  subject_alternative_names = ["*.${var.domain}"]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "primary" {
  name = var.domain
}

resource "aws_route53_record" "validation" {
  zone_id = aws_route53_zone.primary.id

  for_each = {
    for dvo in aws_acm_certificate.default.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true

  ttl = "300"
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
}

resource "aws_acm_certificate_validation" "default" {
  provider = aws
  certificate_arn = aws_acm_certificate.default.arn

  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}