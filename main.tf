terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = "devops-project-513623"
  region  = "us-central1"
  zone    = "us-central1-c"
  credentials = "./keys.json"
}

resource "google_compute_instance" "vm-from-terraform" {
  name = "vm-from-terraform"
  machine_type = "e2-medium"
  zone = "us-central1-c"

  boot_disk {
    initialize_params {
      image = "debian-13-trixie-v20261027"
      size  = 30 # GB
      type  = "pd-ssd"
    }
  }
  network_interface {
    network = "default"
  }

  metadata_startup_script = "echo hi > /test.txt"

  # allow_stopping_for_update = true

}
