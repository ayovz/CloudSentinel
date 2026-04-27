# 📸 CloudSentinel — Screenshot Guide
## Exactly What to Capture and How

6 screenshots. In this exact order.

---

## SCREENSHOT 1 — terraform apply ⭐ Most Important

**What:** Terminal showing Terraform building your AWS infrastructure

**Command to run:**
```bash
terraform -chdir=terraform apply -auto-approve
```

**What good output looks like:**
```
Terraform will perform the following actions:

  # aws_cloudwatch_dashboard.cloudsentinel will be created
  + resource "aws_cloudwatch_dashboard"

  # aws_cloudwatch_metric_alarm.high_cpu will be created
  + resource "aws_cloudwatch_metric_alarm"

  # aws_instance.cloudsentinel will be created
  + resource "aws_instance"

  # aws_s3_bucket.cloudsentinel_logs will be created
  + resource "aws_s3_bucket"

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:
  instance_public_ip = "3.x.x.x"
  instance_id        = "i-0abc123def456789"
  s3_bucket_name     = "cloudsentinel-logs-a1b2c3d4"
```

**Tips:**
- Scroll up to show the "Terraform will perform" section AND the "Apply complete" line
- Make terminal wider so output isn't wrapped
- The green "Apply complete!" line is the money shot

Filename: `01-terraform-apply.png`

---

## SCREENSHOT 2 — EC2 Instance Running on AWS Console

**What:** AWS Console showing your EC2 instance with "Running" status

**Steps:**
1. Go to console.aws.amazon.com
2. Top right — make sure region is ap-south-1 (Mumbai) or wherever you deployed
3. Search for EC2 in the top search bar
4. Click "Instances"
5. You should see "CloudSentinel-instance" with a green "Running" dot

**What to capture:**
- The instance name: CloudSentinel-instance
- The green "Running" status badge
- The Instance ID (i-0abc...)
- The Public IPv4 address

Filename: `02-ec2-running.png`

---

## SCREENSHOT 3 — CloudWatch Dashboard

**What:** Your live monitoring dashboard showing EC2 metrics

**Steps:**
1. In AWS Console, search "CloudWatch"
2. Left sidebar → Dashboards
3. Click "CloudSentinel-dashboard"
4. You should see a graph showing CPU Utilization

**What to capture:**
- The dashboard name "CloudSentinel-dashboard" at the top
- The CPU utilization graph (even if it shows 0% — that's fine)
- The time range selector at the top right

**Bonus:** Also screenshot the Alarms section
1. Left sidebar → Alarms → All alarms
2. You should see "CloudSentinel-high-cpu" with state "OK" or "Insufficient data"

Filename: `03-cloudwatch-dashboard.png`

---

## SCREENSHOT 4 — Health Check Script — All Green ⭐ Most Unique

**What:** Your terminal showing the health-check.sh script passing all checks

**Command:**
```bash
chmod +x scripts/health-check.sh
./scripts/health-check.sh
```

**What to capture:**
```
═══════════════════════════════════════
  CloudSentinel Health Check
  2026-04-27 10:30:00
═══════════════════════════════════════

✅ EC2 instance is RUNNING (i-0abc123def456789)
✅ S3 bucket accessible (cloudsentinel-logs-a1b2c3d4)
✅ CloudWatch alarm configured (OK)

═══════════════════════════════════════
  Health check complete
═══════════════════════════════════════
```

**Why this is the best screenshot:** It proves your automation works —
not just that Terraform ran, but that you verified the result programmatically.
This is SRE thinking.

Filename: `04-health-check-green.png`

---

## SCREENSHOT 5 — GitHub Actions Green ✅

**What:** GitHub showing the CI workflow passed

**Steps:**
1. Push your code: `git push origin main`
2. Go to github.com/ayovz/CloudSentinel
3. Click the "Actions" tab
4. Wait 2-3 minutes for the workflow to complete
5. Screenshot the green checkmark

**What to capture:**
- The workflow name "CloudSentinel Terraform Validate & Plan"
- Green checkmark ✅ next to the run
- The commit message that triggered it

**Bonus:** Click into the run and screenshot the individual steps all showing green.

Filename: `05-github-actions-green.png`

---

## SCREENSHOT 6 — terraform destroy — Clean Teardown

**What:** Terminal showing everything being deleted cleanly

**Command:**
```bash
terraform -chdir=terraform destroy -auto-approve
```

**What to capture:**
```
aws_cloudwatch_metric_alarm.high_cpu: Destroying...
aws_instance.cloudsentinel: Destroying...
aws_s3_bucket.cloudsentinel_logs: Destroying...

Destroy complete! Resources: 5 destroyed.
```

**Why this matters:** Shows you understand cost management and
don't leave orphaned resources running on AWS — a core SRE discipline.

Filename: `06-terraform-destroy.png`

---

## After Taking Screenshots

1. Create a `screenshots/` folder in your project
2. Add all 6 screenshots to it
3. Update README.md — the image paths are already there, just replace
   the placeholder comments with actual images
4. Commit and push:
```bash
git add screenshots/
git add README.md
git commit -m "docs: add infrastructure evidence screenshots"
git push
```

---

## Priority Order

If you only have time for 3:

| Priority | Screenshot | Why |
|---|---|---|
| 🥇 | Screenshot 1 — terraform apply | Proves IaC works |
| 🥈 | Screenshot 4 — health check green | Most unique, shows SRE thinking |
| 🥉 | Screenshot 5 — GitHub Actions green | Proves CI/CD integration |
