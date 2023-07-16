output "external_ip_address_reddit_docker" {
  value = [
    for inst in yandex_compute_instance.reddit_docker :
    "IP of ${inst.name} is ${inst.network_interface.0.nat_ip_address}"
  ]
}
