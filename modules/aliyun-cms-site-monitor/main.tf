resource "alicloud_cms_site_monitor" "site" {
  task_name = var.name
  address   = var.site
  task_type = "HTTP"
  interval  = var.interval
  # 循环依赖
  # alert_ids = [alicloud_cms_alarm.response.id, alicloud_cms_alarm.availability.id]

  # 解决循环依赖: 需要 `apply` 两遍, 第一遍 `alert_ids` 为空数组, 第二遍查询 `alarm` 的 `id` 赋值
  alert_ids = data.alicloud_cms_group_metric_rules.site.rules.*.id

  options_json = jsonencode({
    http_method       = "get"
    match_rule        = 1
    response_content  = var.content
    time_out          = 3000
    unfollow_redirect = true
    cert_verify       = true
  })

  isp_cities {
    city = "304" // 深圳
    isp  = "465" // 阿里
  }

  isp_cities {
    city = "304" // 深圳
    isp  = "132" // 电信
  }

  isp_cities {
    city = "304" // 深圳
    isp  = "5"   // 移动
  }

  isp_cities {
    city = "304" // 深圳
    isp  = "232" // 联通
  }

  isp_cities {
    city = "357" // 上海
    isp  = "465" // 阿里
  }

  isp_cities {
    city = "357" // 上海
    isp  = "132" // 电信
  }

  isp_cities {
    city = "357" // 上海
    isp  = "5"   // 移动
  }

  isp_cities {
    city = "357" // 上海
    isp  = "232" // 联通
  }

  isp_cities {
    city = "738" // 北京
    isp  = "465" // 阿里
  }

  isp_cities {
    city = "738" // 北京
    isp  = "132" // 电信
  }

  isp_cities {
    city = "738" // 北京
    isp  = "5"   // 移动
  }

  isp_cities {
    city = "738" // 北京
    isp  = "232" // 联通
  }
}

resource "alicloud_cms_alarm" "response" {
  name           = "${var.name}_response"
  project        = "acs_networkmonitor"
  metric         = "ResponseTime"
  dimensions     = { taskId = alicloud_cms_site_monitor.site.id }
  silence_time   = var.silence_time
  period         = var.interval * 60
  contact_groups = var.contact

  escalations_warn {
    comparison_operator = ">"
    statistics          = "Average"
    threshold           = 400
    times               = var.times
  }
}

resource "alicloud_cms_alarm" "availability" {
  name           = "${var.name}_availability"
  project        = "acs_networkmonitor"
  metric         = "Availability"
  dimensions     = { taskId = alicloud_cms_site_monitor.site.id }
  silence_time   = var.silence_time
  period         = var.interval * 60
  contact_groups = var.contact

  escalations_warn {
    comparison_operator = "<"
    statistics          = "Average"
    threshold           = 90
    times               = var.times
  }
}

data "alicloud_cms_group_metric_rules" "site" {
  group_metric_rule_name = "demoshare_web"
}
