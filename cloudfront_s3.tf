# Cloudfront distribution for main s3 site.
resource "aws_s3_bucket" "b" {
  bucket = "${var.domain_prefix}.${var.domain_name}"

  tags = {
    Name = "S3 Origin for CloudFront"
  }
}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "public-read"
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.b.id

  policy = data.aws_iam_policy_document.website_policy.json
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.b.id

  index_document {
    suffix = "index1.html"
  }

  error_document {
    key = "index1.html"
  }
}

resource "aws_cloudfront_distribution" "S3_distribution" {
  origin {
    domain_name = aws_s3_bucket.b.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index1.html"

  aliases = ["${var.domain_prefix}.${var.domain_name}"]

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/404.html"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 31536000
    default_ttl            = 31536000
    max_ttl                = 31536000
    compress               = true
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

