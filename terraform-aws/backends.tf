terraform {
  cloud {
    organization = "kraymondlab-terraform"

    workspaces {
      name = "mtc-dev"
    }
  }
}