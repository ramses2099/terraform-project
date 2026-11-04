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

resource "google_compute_instance" "srv-ct-01" {
  boot_disk {
    device_name = "srv-ct-01"    
  }
  confidential_instance_config {
    enable_confidential_compute = false
  }
  description = ""
  instance_encryption_key {
  }
  key_revocation_action_type = "NONE"
  machine_type               = "e2-medium"
  name                       = "srv-ct-01"
  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }
    stack_type         = "IPV4_ONLY"
    subnetwork         = "projects/devops-project-513623/regions/us-central1/subnetworks/default"
    subnetwork_project = "devops-project-513623"
  }
  reservation_affinity {
    type = "ANY_RESERVATION"
  }
  scheduling {
    on_host_maintenance = "MIGRATE"
    provisioning_model  = "STANDARD"
  }
  service_account {
    email  = "service-account-terraform@devops-project-513623.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }
  tags = []
  zone = "us-central1-f"
}

module "ops_agent_policy" {
  source          = "github.com/terraform-google-modules/terraform-google-cloud-operations/modules/ops-agent-policy"
  project         = "devops-project-513623"
  zone            = "us-central1-f"
  assignment_id   = "goog-ops-agent-v2-template-1-7-0-us-central1-f"
  agents_rule = {
    package_state = "installed"
    version = "latest"
  }
  instance_filter = {
    all = false
    inclusion_labels = [{
      labels = {
        goog-ops-agent-policy = "v2-template-1-7-0"
      }
    }]
  }
}
