resource "alicloud_db_database" "database" {
  instance_id   = var.instance
  character_set = "UTF8"
  name          = var.database
}

resource "alicloud_db_account" "account" {
  db_instance_id   = var.instance
  account_type     = "Normal"
  account_name     = var.account
  account_password = var.password

  lifecycle {
    create_before_destroy = true
  }
}

resource "alicloud_db_account_privilege" "privilege" {
  instance_id  = var.instance
  account_name = alicloud_db_account.account.name
  db_names     = [alicloud_db_database.database.name]
  privilege    = "DBOwner"
}
