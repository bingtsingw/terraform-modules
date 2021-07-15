locals {
  image         = "${alicloud_cr_repo.repo.domain_list.public}/${alicloud_cr_repo.repo.id}:init"
  registry      = alicloud_cr_repo.repo.domain_list.public
  downloadImage = "bingtsingw/acr-init-http-server:latest"
}

resource "alicloud_cr_repo" "repo" {
  namespace = var.namespace
  name      = var.name
  summary   = var.name
  repo_type = "PRIVATE"
}

module "ram" {
  source = "github.com/bingtsingw/terraform-modules.git//modules/aliyun-ram-user-policy?ref=v0.17.0"

  name   = "cr-${var.name}"
  policy = <<EOF
  {
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "cr:PushRepository",
          "cr:PullRepository"
        ],
        "Resource": "acs:cr:${var.region}:*:repository/${var.namespace}/${var.name}"
      },
      {
        "Effect": "Allow",
        "Action": "cr:GetAuthorizationToken",
        "Resource": "*"
      }
    ],
    "Version": "1"
  }
  EOF
}

resource "alicloud_ram_access_key" "ak" {
  user_name = module.ram.user.name
}

resource "aliyun_cr_user_info_auth" "auth" {
  access_key = alicloud_ram_access_key.ak.id
  secret_key = alicloud_ram_access_key.ak.secret
  password   = var.docker_password
  region     = var.region
}

resource "null_resource" "image" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
      echo ${var.docker_password} | docker login -u ${var.docker_username} ${local.registry} --password-stdin
      docker pull ${local.downloadImage}
      docker tag ${local.downloadImage} ${local.image}
      docker push ${local.image}
      docker logout ${local.registry}
    EOF
  }
}
