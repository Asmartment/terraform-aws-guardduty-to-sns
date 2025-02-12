variable "finding_publishing_frequency" {
  default     = "ONE_HOUR"
  description = "Frequency with which to publish findings (must be one of `FIFTEEN_MINUTES`, `ONE_HOUR`, `SIX_HOURS`)"
  type        = string
}

variable "guardduty_enabled" {
  default     = true
  description = "Whether or not to enable the GuardDuty service"
}

variable "notification_arn" {
  description = "SNS Topic to send notifications to"
  type        = string
}
variable "dlq_arn" {
  description = "sqs queue for failed event invocations"
  type        = string
}

variable "tags" {
  default     = {}
  description = "User-Defined tags"
  type        = map(string)
}
