terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "consul" {}
}

# Template provider
provider "template" {
  version = "~> 1.0"
}

# Get the project data
data "rancher_environment" "project" {
  name = "${var.project_name}"
}




data "template_file" "docker_compose_cerebro" {
  template = "${file("${path.module}/rancher/cerebro/docker-compose.yml")}"

  vars {
    label_scheduling        = "${var.label_scheduling}"
    global_scheduling       = "${var.global_scheduling}"
    image_version           = "${var.image_version}"
    mem_limit               = "${var.container_memory != "" ? "mem_limit: ${var.container_memory}" : ""}"
    cpu_shares              = "${var.cpu_shares}"
  }
}
data "template_file" "rancher_compose_cerebro" {
  template = "${file("${path.module}/rancher/cerebro/rancher-compose.yml")}"

  vars {
     scale  = "${var.scale != "" ? "scale: ${var.scale}" : ""}"
  }
}
resource "rancher_stack" "this" {
  name            = "${var.stack_name}"
  description     = "Cerebro - Elasticsearch Management"
  environment_id  = "${data.rancher_environment.project.id}"
  scope           = "user"
  start_on_create = true
  finish_upgrade  = "${var.finish_upgrade}"
  docker_compose  = "${data.template_file.docker_compose_cerebro.rendered}"
  rancher_compose = "${data.template_file.rancher_compose_cerebro.rendered}"
}