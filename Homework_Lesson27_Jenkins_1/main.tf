provider "google" {
  project = "oceanic-base-450915-k4"
  region  = "europe-north1-b"
}

resource "google_compute_instance" "jenkins_vm_med" {
  name         = "jenkins-vm-med"
  machine_type = "e2-medium"
  zone         = "europe-north1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "34.89.221.182"
    }
  }

  tags = ["http-server", "https-server"]
}
