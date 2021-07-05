locals {
  name_dash     = replace(var.name, "_", "-")
  name_line     = replace(var.name, "-", "_")
  name_service  = replace(local.name_dash, "fc-", "")
  name_function = local.name_service

  name_dash_prod    = "${local.name_dash}-prod"
  name_line_prod    = "${local.name_line}_prod"
  name_service_prod = "${local.name_service}-prod"

  name_dash_dev    = "${local.name_dash}-dev"
  name_line_dev    = "${local.name_line}_dev"
  name_service_dev = "${local.name_service}-dev"

  role_document = <<EOF
  {
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": [
            "fc.aliyuncs.com"
          ]
        }
      }
    ],
    "Version": "1"
  }
  EOF

  policy_document_template_log = <<EOF
  {
    "Statement": [
      {
          "Action": [
              "log:PostLogStoreLogs"
          ],
          "Resource": "*",
          "Effect": "Allow"
      }
    ],
    "Version": "1"
  }
  EOF

  policy_document_template_log_cr = <<EOF
  {
    "Statement": [
      {
          "Action": [
              "log:PostLogStoreLogs"
          ],
          "Resource": "*",
          "Effect": "Allow"
      },
      {
          "Action": [
              "cr:GetRepository",
              "cr:GetRepositoryTag",
              "cr:GetAuthorizationToken",
              "cr:PullRepository"
          ],
          "Resource": "*",
          "Effect": "Allow"
      }
    ],
    "Version": "1"
  }
  EOF

  policy_document_template_log_cr_vpc = <<EOF
  {
    "Statement": [
      {
          "Action": [
              "log:PostLogStoreLogs"
          ],
          "Resource": "*",
          "Effect": "Allow"
      },
      {
          "Action": [
              "cr:GetRepository",
              "cr:GetRepositoryTag",
              "cr:GetAuthorizationToken",
              "cr:PullRepository"
          ],
          "Resource": "*",
          "Effect": "Allow"
      },
      {
        "Effect": "Allow",
        "Action": "vpc:DescribeVSwitchAttributes",
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ecs:CreateNetworkInterface",
          "ecs:DeleteNetworkInterface",
          "ecs:DescribeNetworkInterfaces",
          "ecs:CreateNetworkInterfacePermission",
          "ecs:DescribeNetworkInterfacePermissions",
          "ecs:DeleteNetworkInterfacePermission"
        ],
        "Resource": "*"
      }
    ],
    "Version": "1"
  }
  EOF
}
