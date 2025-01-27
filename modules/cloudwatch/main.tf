resource "aws_iam_policy" "custom_policy" {
  name        = "CustomPolicy"
  description = "Custom policy for EC2 to send logs to CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "custom_policy_attachment" {
  name       = "ec2-custom-policy-attachment"
  roles      = [aws_iam_role.cloudwatch_agent_role.name]
  policy_arn = aws_iam_policy.custom_policy.arn
}

# Crear un Instance Profile para asociarlo al EC2
resource "aws_iam_instance_profile" "cloudwatch_instance_profile" {
  name = "cloudwatch-instance-profile-${var.project_name}"
  role = aws_iam_role.cloudwatch_agent_role.name
}

# Crear un Log Group en CloudWatch
resource "aws_cloudwatch_log_group" "web_server_logs" {
  name              = "/web-app/nginx-logs-${var.project_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Environment = var.environment
  }
}

# Crear un Log Stream dentro del Log Group
resource "aws_cloudwatch_log_stream" "nginx_log_stream" {
  name           = "nginx-log-stream"
  log_group_name = aws_cloudwatch_log_group.web_server_logs.name
}

# Crear un Role para CloudWatch Agent (para Nginx logs y métricas)
resource "aws_iam_role" "cloudwatch_agent_role" {
  name = "cloudwatch-agent-role-${var.project_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Agregar políticas al Role para permitir CloudWatch Logs y métricas
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy" {
  role       = aws_iam_role.cloudwatch_agent_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Crear Alarmas para monitorear el EC2
resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "High-CPU-Usage-${var.project_name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alarm when EC2 CPU exceeds 70%"
  actions_enabled     = true

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_actions = var.alarm_actions
}

resource "aws_cloudwatch_metric_alarm" "status_check_failed_alarm" {
  alarm_name          = "Instance-Status-Failed-${var.project_name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Alarm when instance status check fails"
  actions_enabled     = true

  dimensions = {
    InstanceId = var.instance_id
  }

  alarm_actions = var.alarm_actions
}
