variable "aws_region" {
    description = "AWS region to deploy resources"
    type        = string
    default     = "ap-south-1"
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t2.micro"
}

variable "project_name" {
    description = "Name tag for all resources"
    type        = string
    default     = "CloudSentinel"
}

variable "cpu_alarm_threshold" {
    description = "CPU utilisation % to trigger alarm"
    type        = number
    default     = 70
}