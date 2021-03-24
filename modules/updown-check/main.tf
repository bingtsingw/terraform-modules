resource "updown_check" "check" {
  url                = var.url
  apdex_t            = var.apdex_t
  period             = var.period
  disabled_locations = var.disabled_locations
  enabled            = var.enabled
  published          = var.published
  string_match       = var.string_match
}
