resource "aws_route53_zone" "primary" {
  name = "jacobtleblanc.portfolio.com"
}

resource "aws_route53_record" "primary_record" {
  zone_id = aws_route53_zone.primary.id
  name = aws_route53_zone.primary.name
  type = NS

  records = aws_route53_zone.primary.name_servers
}