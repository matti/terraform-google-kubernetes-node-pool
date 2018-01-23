data "google_container_cluster" "cluster" {
  name = "${local.merged_settings["cluster_name"]}"
  zone = "${local.merged_settings["cluster_zone"]}"
}

resource "google_container_node_pool" "autoscaling" {
  count = "${local.merged_settings["autoscaling"] ? 1 : 0}"

  zone    = "${data.google_container_cluster.cluster.zone}"
  cluster = "${data.google_container_cluster.cluster.name}"

  autoscaling {
    min_node_count = "${local.merged_settings["autoscaling_min_node_count"]}"
    max_node_count = "${local.merged_settings["autoscaling_max_node_count"]}"
  }

  #initial_node_count (deprecated)
  management {
    auto_repair  = "${local.merged_settings["node_auto_repair"]}"
    auto_upgrade = "${local.merged_settings["node_auto_upgrade"]}"
  }

  name = "${local.merged_settings["name"]}"

  #name_prefix
  node_config = ["${local.node_config}"]

  #node_count # This is autoscaling resource
  #project
}

resource "google_container_node_pool" "fixed" {
  count = "${local.merged_settings["autoscaling"] ? 0 : 1}"

  zone    = "${data.google_container_cluster.cluster.zone}"
  cluster = "${data.google_container_cluster.cluster.name}"

  #initial_node_count (deprecated)
  management {
    auto_repair  = "${local.merged_settings["node_auto_repair"]}"
    auto_upgrade = "${local.merged_settings["node_auto_upgrade"]}"
  }

  name = "${local.merged_settings["name"]}"

  #name_prefix

  node_config = ["${local.node_config}"]
  node_count  = "${local.merged_settings["node_count"]}"

  #project
}
