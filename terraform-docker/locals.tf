locals {
  deployment = {
    nodered = {
      cont_count = length(var.ext_port["nodered"][terraform.workspace])
      image      = var.image["nodered"][terraform.workspace]
      int        = 1880
      ext        = var.ext_port["nodered"][terraform.workspace]
      volumes = [
        { container_path_each = "/data" }
      ]
    }
    influxdb = {
      cont_count = length(var.ext_port["influxdb"][terraform.workspace])
      image      = var.image["influxdb"][terraform.workspace]
      int        = 8086
      ext        = var.ext_port["influxdb"][terraform.workspace]
      volumes = [
        { container_path_each = "/var/lib/influxdb" },
        { container_path_each = "/etc/influxdb" }
      ]
    }
    grafana = {
      cont_count = length(var.ext_port["grafana"][terraform.workspace])
      image      = var.image["grafana"][terraform.workspace]
      int        = 3000
      ext        = var.ext_port["grafana"][terraform.workspace]
      volumes = [
        { container_path_each = "/var/lib/grafana" },
        { container_path_each = "/etc/grafana" }
      ]
    }
  }
}
