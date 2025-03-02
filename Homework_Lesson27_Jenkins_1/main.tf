provider "google" {
  project = "oceanic-base-450915-k4"  # Укажите ваш GCP Project ID
  region  = "europe-west3"
}

resource "google_compute_instance" "jenkins_vm" {
  name         = "jenkins-vm"
  machine_type = "e2-micro"
  zone         = "europe-west3-c"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "35.246.158.16"
    }
  }

  tags = ["http-server", "https-server"]
}
