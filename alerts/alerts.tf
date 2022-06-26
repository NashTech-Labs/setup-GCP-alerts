locals {
  log_based_slack_alerts_configs ={
    for alc in var.slack_alert_policy_configs :
    alc.alert_display_name => {
        filter = alc.filter
        notification_channels = alc.notification_channels
        condition_display_name = alc.condition_display_name
        alert_strategy = alc.alert_strategy
        content = alc.content
    }
  }
  log_based_pagerduty_alerts_configs={
    for alc in var.pagerduty_alert_policy_configs :
    alc.alert_display_name => {
        filter = alc.filter
        notification_channels = alc.notification_channels
        condition_display_name = alc.condition_display_name
        alert_strategy = alc.alert_strategy
        content = alc.content
    }
  }
  log_based_email_alerts_configs={
    for alc in var.email_alert_policy_configs :
    alc.alert_display_name => {
        filter = alc.filter
        notification_channels = alc.notification_channels
        condition_display_name = alc.condition_display_name
        alert_strategy = alc.alert_strategy
        content = alc.content
    }
  }
}

resource "google_monitoring_alert_policy" "slack_alert_policy" {
  for_each = local.log_based_slack_alerts_configs
  display_name = each.key
  documentation {
    content   = each.value.content
    mime_type = "text/markdown"
  }
  enabled = true
  alert_strategy {
    notification_rate_limit {
      period = each.value.alert_strategy.period
    }
    auto_close = each.value.alert_strategy.auto_close
  }
  notification_channels = data.google_monitoring_notification_channel.slack_channels[*].id
  combiner              = "OR"
  conditions {
    display_name = each.value.condition_display_name
    condition_matched_log {
      filter = each.value.filter
    }
  }
}

resource "google_monitoring_alert_policy" "pagerduty_alert_policy" {
  for_each = local.log_based_pagerduty_alerts_configs
  display_name = each.key
  documentation {
    content   = each.value.content
    mime_type = "text/markdown"
  }
  enabled = true
  alert_strategy {
    notification_rate_limit {
      period = each.value.alert_strategy.period
    }
    auto_close = each.value.alert_strategy.auto_close
  }
  notification_channels = data.google_monitoring_notification_channel.pagerduty_channels[*].id
  combiner              = "OR"
  conditions {
    display_name = each.value.condition_display_name
    condition_matched_log {
      filter = each.value.filter
    }
  }
}

resource "google_monitoring_alert_policy" "email_alert_policy" {
  for_each = local.log_based_email_alerts_configs
  display_name = each.key
  documentation {
    content   = each.value.content
    mime_type = "text/markdown"
  }
  enabled = true
  alert_strategy {
    notification_rate_limit {
      period = each.value.alert_strategy.period
    }
    auto_close = each.value.alert_strategy.auto_close
  }
  notification_channels = data.google_monitoring_notification_channel.email_channels[*].id
  combiner              = "OR"
  conditions {
    display_name = each.value.condition_display_name
    condition_matched_log {
      filter = each.value.filter
    }
  }
}

data "google_monitoring_notification_channel" "slack_channels" {
  count = length(var.slack_alert_policy_configs) > 0 ?length(var.slack_alert_policy_configs[0].notification_channels):0
  display_name = var.slack_alert_policy_configs[0].notification_channels[count.index]
}


data "google_monitoring_notification_channel" "pagerduty_channels" {
  
  count = length(var.pagerduty_alert_policy_configs) > 0 ?length(var.pagerduty_alert_policy_configs[0].notification_channels):0
  display_name = var.pagerduty_alert_policy_configs[0].notification_channels[count.index]
}


data "google_monitoring_notification_channel" "email_channels" {
  
  count = length(var.email_alert_policy_configs) > 0 ?length(var.email_alert_policy_configs[0].notification_channels):0
  display_name = var.email_alert_policy_configs[0].notification_channels[count.index]
}
