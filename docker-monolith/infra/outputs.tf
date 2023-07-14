output "external_ip_address_apps" {
  value = [
    for inst in yandex_compute_instance.app :
    "IP of ${inst.name} is ${inst.network_interface.0.nat_ip_address}"
  ]
}
