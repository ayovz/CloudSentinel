# ─────────────────────────────────────────────
#  CloudSentinel — IaC Infrastructure Stack
#  Author: Ayomal Weerasinghe
# ─────────────────────────────────────────────

# S3 Bucket — Log storage
resource "aws_s3_bucket" "cloudsentinel_logs" {
    bucket = "${lower(var.project_name)}-logs-${random_id.suffix.hex}"

    tags = {
    Name        = "${var.project_name}-logs"
    Project     = var.project_name
    ManagedBy   = "Terraform"
    }
}

resource "random_id" "suffix" {
    byte_length = 4
}

# Security Group — Allow SSH + HTTP
resource "aws_security_group" "cloudsentinel_sg" {
    name        = "${var.project_name}-sg"
    description = "CloudSentinel security group"

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
    }

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
    }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
    Name      = "${var.project_name}-sg"
    ManagedBy = "Terraform"
    }
}

# EC2 Instance
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners      = ["amazon"]

    filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_instance" "cloudsentinel" {
    ami                    = data.aws_ami.amazon_linux.id
    instance_type          = var.instance_type
    vpc_security_group_ids = [aws_security_group.cloudsentinel_sg.id]

    user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y python3
    echo "CloudSentinel instance ready" > /var/log/cloudsentinel.log
    EOF

    tags = {
    Name      = "${var.project_name}-instance"
    Project   = var.project_name
    ManagedBy = "Terraform"
    }
}

# CloudWatch CPU Alarm
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
    alarm_name          = "${var.project_name}-high-cpu"
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = 2
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = 120
    statistic           = "Average"
    threshold           = var.cpu_alarm_threshold
    alarm_description   = "Triggers when CPU exceeds ${var.cpu_alarm_threshold}%"

    dimensions = {
    InstanceId = aws_instance.cloudsentinel.id
    }

    tags = {
    Name      = "${var.project_name}-cpu-alarm"
    ManagedBy = "Terraform"
    }
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "cloudsentinel" {
    dashboard_name = "${var.project_name}-dashboard"

    dashboard_body = jsonencode({
    widgets = [
        {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 24
        height = 6
        properties = {
            title   = "CloudSentinel — CPU Utilisation"
            region  = var.aws_region
            period  = 300
            metrics = [
            ["AWS/EC2", "CPUUtilization",
                "InstanceId", aws_instance.cloudsentinel.id]
            ]
            view = "timeSeries"
            stat = "Average"
        }
        }
    ]
    })
}