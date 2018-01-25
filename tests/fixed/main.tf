provider "google" {}
data "google_client_config" "current" {}

module "test" {
  source = "github.com/matti/terraform-google-kubernetes-engine"

  settings = {
    region_name            = "${data.google_client_config.current.region}"
    zone_amount            = 1
    cluster_name           = "node-pool-test-fixed"
    gke_min_master_version = "1.8.6-gke.0"
  }
}

locals {
  common_settings = {
    cluster_name = "${module.test.cluster_name}"
    cluster_zone = "${module.test.cluster_zone}"
  }

  common_labels = {
    common_label1 = "common_value1"
  }

  common_tags = ["common_tag1"]
}

locals {
  np_fixed_settings = {
    name       = "fixed"
    node_count = 2
  }

  np_fixed_labels = {
    testing_label1 = "testing_value1"
    testing_label2 = "testing_value2"
  }

  np_fixed_tags = ["tag1"]
}

module "testing_node_pool" {
  source   = "../.."
  settings = "${merge(local.common_settings, local.np_fixed_settings)}"
  labels   = "${merge(local.common_labels, local.np_fixed_labels)}"
  tags     = "${concat(local.common_tags, local.np_autoscaling_tags)}"
}
