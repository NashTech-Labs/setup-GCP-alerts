# Add Prometheus Datasources in Grafana

## Prerequisite

1. GCP Project ID
2. Log filter or Queries to setup alerts
3. Notification Channels setuped in GCP to send alerts. (Slack or Pagerduty or email)
4. Markdown Doc to send with alerts.

## Setup Authentication

Export environment variable for authentication

```bash
export GOOGLE_APPLICATION_CREDENTIALS="path/to/SA-key.json"
```


## Add Logbased Alerts

First convert your markdown doc into a string.

```bash
sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' path/to/file.md
```

This string will be used in `content` field of alerts configs.

### Step 1

1. Open [alerts_config.auto.tfvars](./alerts_config.auto.tfvars) file
2. Add alerts configs map object below the commented object.

```bash
email_alert_policy_configs = [
  # {
  #   alert_display_name     = "Your email Alert Name"
  #   filter                 = "log queries filters"
  #   notification_channels  = ["Display name of Email notification channels"]
  #   condition_display_name = "Name of the Condition"
  #   alert_strategy = {
  #     period     = "300s"
  #     auto_close = "1800s"
  #   }
  #   content = "Markdown file in string. Read README.md for convert file into String"
  # }
]
```

### Step 2

1. Install provider plugins

```bash
terraform init
```

2. Check Terraform plan

```
terraform plan
```

3. Apply the terraform configurations

```
terraform apply
```