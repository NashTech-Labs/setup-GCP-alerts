terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.20.0"
    } 
  }
}

module "log-based-alerts" {
  slack_alert_policy_configs     = var.slack_alert_policy_configs
  pagerduty_alert_policy_configs = var.pagerduty_alert_policy_configs
  email_alert_policy_configs = var.email_alert_policy_configs
  source                         = "./alerts"
}
