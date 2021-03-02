terraform {
  required_providers {
    acme = {
      source  = "vancluever/acme"
    }
  }
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
