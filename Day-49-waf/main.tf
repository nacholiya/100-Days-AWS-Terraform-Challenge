resource "aws_wafv2_web_acl" "web_acl" {
  name  = "day-49-web-acl"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "Day-49-waf-metric"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "aws-common-rule-set"
    priority = 1
    override_action {
      none {
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Day-49-waf-rule-1-metric"
      sampled_requests_enabled   = true
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }
  }
}