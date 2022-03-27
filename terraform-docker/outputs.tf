# output "name" {
#   value = module.container[*].container-name
# }

# output "IP_Port" {
#   value       = flatten(module.container[*].container_IP_Port)
#   description = "Internal IP of the server"
#   #  sensitive   = true
# }

output "application_access" {
  value       = [for x in module.container[*] : x]
  description = "Name and socket for each application"
}