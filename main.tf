resource "aws_guardduty_detector" "this" {
  enable                       = var.guardduty_enabled
  finding_publishing_frequency = var.finding_publishing_frequency
  tags                         = var.tags
}

resource "aws_cloudwatch_event_rule" "this" {
  name        = "guardduty-events"
  description = "GuardDutyEvent"
  is_enabled  = var.guardduty_enabled
  tags        = var.tags

  event_pattern = <<PATTERN
{
  "source": [
    "aws.guardduty"
  ]
}
PATTERN
}

resource "aws_cloudwatch_event_target" "this" {
  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "SendToSNS"
  arn       = var.notification_arn
  dead_letter_config {
    arn = var.dlq_arn
  }
}

