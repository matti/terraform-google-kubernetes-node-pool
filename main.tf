data "google_container_cluster" "cluster" {
  name = "${local.cluster_name}"
  zone = "${local.cluster_zone}"
}

resource "google_container_node_pool" "autoscaling" {
  zone    = "${data.google_container_cluster.cluster.zone}"
  cluster = "${data.google_container_cluster.cluster.name}"

  node_count = "${local.autoscaling_min_node_count}"

  autoscaling {
    min_node_count = "${local.autoscaling_min_node_count}"
    max_node_count = "${local.autoscaling_max_node_count}"
  }

  #initial_node_count (deprecated)
  management {
    auto_repair  = "${local.node_auto_repair}"
    auto_upgrade = "${local.node_auto_upgrade}"
  }

  name = "${local.name}"

  #name_prefix
  node_config = ["${local.node_config}"]

  #project
}
