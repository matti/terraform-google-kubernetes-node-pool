provider "google" {}
data "google_client_config" "current" {}

module "test" {
  source = "github.com/matti/terraform-google-kubernetes-engine"

  settings = {
    region_name            = "${data.google_client_config.current.region}"
    zone_amount            = 1
    cluster_name           = "node-pool-test-wolabelstags"
    gke_min_master_version = "1.8.6-gke.0"
  }
}

locals {
  common_settings = {
    cluster_name = "${module.test.cluster_name}"
    cluster_zone = "${module.test.cluster_zone}"
  }
}

locals {
  np_wolabelstags_settings = {
    name       = "wolabelstags"
    node_count = 1
  }
}

module "testing_node_pool" {
  source   = "../.."
  settings = "${merge(local.common_settings, local.np_wolabelstags_settings)}"
}
