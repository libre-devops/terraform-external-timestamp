terraform {
  #Use the latest by default, uncomment below to pin or use hcl.lck
  required_providers {
    external = {
      source = "hashicorp/external"
    }
  }
}