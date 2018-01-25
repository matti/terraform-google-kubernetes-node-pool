variable "settings" {
  default = {}
}

variable "labels" {
  default = {}
}

variable "tags" {
  default = []
}

locals {
  name                       = "${lookup(var.settings, "name")}"
  cluster_name               = "${lookup(var.settings, "cluster_name")}"
  cluster_zone               = "${lookup(var.settings, "cluster_zone")}"
  node_count                 = "${lookup(var.settings, "node_count", 0)}"
  autoscaling_min_node_count = "${lookup(var.settings, "autoscaling_min_node_count", local.node_count)}"

  # minimum is 1
  autoscaling_max_node_count = "${lookup(var.settings, "autoscaling_max_node_count", (local.node_count == 0 ? 1 : local.node_count))}"
  node_auto_repair           = "${lookup(var.settings, "node_auto_repair", false)}"
  node_auto_upgrade          = "${lookup(var.settings, "node_auto_upgrade", false)}"
  disk_size_gb               = "${lookup(var.settings, "disk_size_gb", 100)}"
  machine_type               = "${lookup(var.settings, "machine_type", "n1-standard-1")}"
  preemptible                = "${lookup(var.settings, "preemptible", false)}"

  tags   = "${var.tags}"
  labels = "${var.labels}"
}

locals {
  node_config = {
    disk_size_gb = "${local.disk_size_gb}"

    #image_type
    labels = "${local.labels}"

    #local_ssd_count
    machine_type = "${local.machine_type}"

    #metadata
    #min_cpu_platform
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    preemptible = "${local.preemptible}"

    #service_account
    tags = "${local.tags}"
  }
}
