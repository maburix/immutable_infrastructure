output "url_test" {
    value = "${ format("%s://%s%s", "http", aws_route53_record.maburix-demo.fqdn, "/") }"
}
