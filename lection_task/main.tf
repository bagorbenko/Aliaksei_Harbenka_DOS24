provider "google" {
  project = "oceanic-base-450915-k4"
  region  = "europe-north1"
}

resource "google_compute_instance_template" "instance_template" {
  name         = "instance-template"
  machine_type = "e2-micro"

  disk {
    boot         = true
    auto_delete  = true
    source_image = "ubuntu-os-cloud/ubuntu-2204-lts"
  }

  metadata_startup_script = <<EOT
    #!/bin/bash
    sudo apt update
    sudo apt install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOT

  network_interface {
    network = "default"
    access_config {} 
  }
}


resource "google_compute_region_instance_group_manager" "mig" {
  name               = "managed-instance-group"
  base_instance_name = "vm"
  region             = "europe-north1"

  version {
    instance_template = google_compute_instance_template.instance_template.self_link
  }

  target_size = 3

  named_port {
    name = "http"
    port = 80
  }
}


resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}


resource "google_compute_health_check" "http" {
  name                = "http-health-check"
  timeout_sec         = 10
  check_interval_sec  = 15
  healthy_threshold   = 2
  unhealthy_threshold = 5

  http_health_check {
    port         = 80
  }
}


resource "google_compute_backend_service" "backend" {
  name                  = "backend-service"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.http.self_link]

  backend {
    group = google_compute_region_instance_group_manager.mig.instance_group
  }
}


resource "google_compute_url_map" "url_map" {
  name            = "url-map"
  default_service = google_compute_backend_service.backend.self_link
}


resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}


resource "google_compute_global_forwarding_rule" "http_forwarding" {
  name       = "http-forwarding-rule"
  target     = google_compute_target_http_proxy.http_proxy.self_link
  port_range = "80"
}
