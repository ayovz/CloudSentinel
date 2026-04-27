output "instance_public_ip" {
  description = "Public IP of the CloudSentinel EC2 instance"
  value       = aws_instance.cloudsentinel.public_ip
}

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.cloudsentinel.id
}

output "s3_bucket_name" {
  description = "S3 bucket for log storage"
  value       = aws_s3_bucket.cloudsentinel_logs.bucket
}

output "cloudwatch_dashboard_url" {
  description = "CloudWatch dashboard URL"
  value       = "https://console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${var.project_name}-dashboard"
}