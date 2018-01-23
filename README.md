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

  baseline_settings = {
    name                       = "baseline"
    node_count                 = 1
    machine_type               = "n1-highcpu-4"
  }

  work_settings = {
    name                       = "work"
    preemptible                = true
    machine_type               = "n1-highcpu-4"
    autoscaling                = true
    autoscaling_min_node_count = 0
    autoscaling_max_node_count = 3
  }
}

module "baseline_node_pool" {
  source = "github.com/matti/terraform-google-kubernetes-node-pool"

  settings = "${merge(local.common_settings, local.baseline_settings)}"
}

module "mycluster_node_pool_autoscale" {
  source = "github.com/matti/terraform-google-kubernetes-node-pool"

  settings = "${merge(local.common_settings, local.work_settings)}"
}
````
