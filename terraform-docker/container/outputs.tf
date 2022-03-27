# output "container_IP_Port" {
#   value       = [for x in docker_container.nodered_container[*] : join(":", [x.name], [x.ip_address], [x.ports[0]["external"]])]
#   description = "Internal IP of the server"
# #  sensitive   = true
# }

# output "container-name" {
#     value = docker_container.nodered_container.name
# }

output "application_access" {
  value = { for i in docker_container.app_container[*] : i.name => join(":", [i.ip_address], i.ports[*]["external"]) }
}