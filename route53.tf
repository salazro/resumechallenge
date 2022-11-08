#Create A record for CNAME
resource "aws_route53_record" "www" {
  zone_id = "your hosted zone id"
  name    = "${var.domain_prefix}.${var.domain_name}"
  type    = "A"
  #ttl     = 300
  #records = [aws_eip.lb.public_ip]

  alias {
    name = aws_cloudfront_distribution.S3_distribution.domain_name
    zone_id = aws_cloudfront_distribution.S3_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}

