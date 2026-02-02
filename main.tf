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
  ],
  "detail.severity":[ { "numeric": [ ">", 4] } ]
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


resource "aws_cloudwatch_metric_alarm" "FailedInvocation" {
  alarm_name = "gaurd-duty-event-failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  period = "3600"
  metric_query {
    id = "m1"
    metric {
      metric_name = "FailedInvocations"
      namespace = "AWS/Events"
      period = 3600
      stat = "Sum"
      unit = "Count"
      dimensions = {
          RuleName = aws_cloudwatch_event_rule.this.name
      }
    }
  }
  alarm_description = "Guard Duty Finding Event rule failed to invoke. This is only informational. Failed are routed to SQS DLQ and finally to this slack channel"
  alarm_actions = [var.notification_arn]

}
