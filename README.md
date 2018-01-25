# terraform-google-kubernetes-node-pool

See also http://github.com/matti/terraform-google-kubernetes-engine

## Usage

```
module "mycluster" {
  source = "github.com/matti/terraform-google-kubernetes-engine"

  settings = {
    region_name            = "europe-west1"
    zone_amount            = 3
    cluster_name           = "mycluster"
    gke_min_master_version = "1.8.6-gke.0"
  }
}

locals {
  common_settings = {
    cluster_name = "${module.mycluster.cluster_name}"
    cluster_zone = "${module.mycluster.cluster_zone}"

    node_auto_repair  = true
    node_auto_upgrade = true
  }

  common_labels = {
    common_label1 = "value1"
    common_label2 = "value2"
  }

  common_tags = ["every"]

  baseline_settings = {
    name                       = "baseline"
    node_count                 = 1
    machine_type               = "n1-highcpu-4"
  }

  baseline_labels = {
    baseline_label1 = "value1"
  }

  baseline_tags = ["tag1"]

  work_settings = {
    name                       = "work"
    preemptible                = true
    machine_type               = "n1-highcpu-4"
    autoscaling_min_node_count = 0
    autoscaling_max_node_count = 3
  }
}

module "mycluster_baseline_node_pool" {
  source = "github.com/matti/terraform-google-kubernetes-node-pool"

  settings = "${merge(local.common_settings, local.baseline_settings)}"
  labels   = "${merge(local.common_labels, local.baseline_labels)}"
  tags     = "${concat(local.common_tags, local.baseline_tags)}"
}

module "mycluster_node_pool_work" {
  source = "github.com/matti/terraform-google-kubernetes-node-pool"
  settings = "${merge(local.common_settings, local.work_settings)}"
}
```

## Test

  GOOGLE_PROJECT=your-project GOOGLE_REGION=europe-west1 test/test.sh <testname>