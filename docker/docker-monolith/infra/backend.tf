terraform {
  backend "s3" {
    endpoint                = "storage.yandexcloud.net"
    bucket                  = "terraform-2-stage-bucket"
    region                  = "ru-central1"
    key                     = "stage/terraform.tfstate"
    shared_credentials_file = "/home/lenar/.aws/credentials"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
