data "aws_route53_zone" "hosted_zone" {
  name = var.root_domain_name
}
