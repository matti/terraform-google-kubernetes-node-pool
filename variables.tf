variable "settings" {
  default = {}
}

# map "local.merged_settings" does not have homogenous types. found TypeList and then TypeString
variable "tags" {
  default = []
}

locals {
  default_settings = {
    node_count                 = 0
    autoscaling                = false
    autoscaling_min_node_count = 0
    autoscaling_max_node_count = 0
    node_auto_repair           = false
    node_auto_upgrade          = false
    disk_size_gb               = 100
    machine_type               = "n1-standard-1"
    preemptible                = false
  }

  merged_settings = "${merge(local.default_settings, var.settings)}"

  node_config = {
    disk_size_gb = "${local.merged_settings["disk_size_gb"]}"

    #image_type
    #labels
    #local_ssd_count
    machine_type = "${local.merged_settings["machine_type"]}"

    #metadata
    #min_cpu_platform
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    preemptible = "${local.merged_settings["preemptible"]}"

    #service_account
    tags = "${var.tags}"
  }
}
