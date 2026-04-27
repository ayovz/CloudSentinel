#!/bin/bash
# ─────────────────────────────────────────────
#  CloudSentinel Health Check
#  Validates provisioned infrastructure
# ─────────────────────────────────────────────

echo "═══════════════════════════════════════"
echo "  CloudSentinel Health Check"
echo "  $(date '+%Y-%m-%d %H:%M:%S')"
echo "═══════════════════════════════════════"

# Get Terraform outputs
INSTANCE_IP=$(terraform -chdir=terraform output -raw instance_public_ip 2>/dev/null)
INSTANCE_ID=$(terraform -chdir=terraform output -raw instance_id 2>/dev/null)
S3_BUCKET=$(terraform -chdir=terraform output -raw s3_bucket_name 2>/dev/null)
REGION=$(terraform -chdir=terraform output -raw aws_region 2>/dev/null || echo "ap-south-1")

# Check 1: EC2 instance state
echo ""
echo "Checking EC2 instance state..."
STATE=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].State.Name' \
  --output text 2>/dev/null)

if [ "$STATE" = "running" ]; then
  echo "✅ EC2 instance is RUNNING ($INSTANCE_ID)"
else
  echo "❌ EC2 instance state: $STATE"
fi

# Check 2: S3 bucket accessible
echo ""
echo "Checking S3 bucket..."
if aws s3 ls "s3://$S3_BUCKET" > /dev/null 2>&1; then
  echo "✅ S3 bucket accessible ($S3_BUCKET)"
else
  echo "❌ S3 bucket not accessible"
fi

# Check 3: CloudWatch alarm state
echo ""
echo "Checking CloudWatch alarm..."
ALARM_STATE=$(aws cloudwatch describe-alarms \
  --alarm-names "CloudSentinel-high-cpu" \
  --query 'MetricAlarms[0].StateValue' \
  --output text 2>/dev/null)

if [ "$ALARM_STATE" = "OK" ] || [ "$ALARM_STATE" = "INSUFFICIENT_DATA" ]; then
  echo "✅ CloudWatch alarm configured ($ALARM_STATE)"
else
  echo "⚠️  CloudWatch alarm state: $ALARM_STATE"
fi

echo ""
echo "═══════════════════════════════════════"
echo "  Health check complete"
echo "═══════════════════════════════════════"