output "iam_instance_profile" {
  value = aws_iam_instance_profile.cloudwatch_instance_profile.name
}

output "log_group_name" {
  value       = aws_cloudwatch_log_group.web_server_logs.name
  description = "Name of the CloudWatch Log Group"
}

output "high_cpu_alarm_name" {
  value       = aws_cloudwatch_metric_alarm.high_cpu_alarm.alarm_name
  description = "Name of the High CPU usage alarm"
}

output "status_check_failed_alarm_name" {
  value       = aws_cloudwatch_metric_alarm.status_check_failed_alarm.alarm_name
  description = "Name of the status check failed alarm"
}