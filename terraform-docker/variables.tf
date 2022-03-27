# variable "env" {
#   type        = string
#   default     = "dev"
#   description = "deploment env"
# }

variable "image" {
  type = map(any)
  default = {
    nodered = {
      dev  = "nodered/node-red:latest"
      prod = "nodered/node-red:latest-minimal"
    }
    influxdb = {
      dev  = "quay.io/influxdb/influxdb:v2.0.2"
      prod = "quay.io/influxdb/influxdb:v2.0.2"
    }
    grafana = {
      dev  = "grafana/grafana-oss"
      prod = "grafana/grafana-enterprise"
    }
  }
}

variable "ext_port" {
  type = map(any)
  #  sensitive = true
}

variable "cont_count" {
  default = 4
}

