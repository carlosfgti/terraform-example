terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "github" {
  token = var.github_token
}

resource "google_compute_address" "static_ip" {
  name = "my-static-ip"
}

provider "google" {
  credentials = file("gcp.json")

  project = "terraform-tests-403719"
  region  = "us-east1"
  zone    = "us-east1-c"
}

resource "google_compute_instance" "terraform_test" {
  count = 1
  name = "terraform${count.index + 1}"
  machine_type = "e2-small"
  zone = "us-east1-c"

  boot_disk {
    initialize_params {
      image = var.image
      size = "10"
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  tags = ["${var.tag}${count.index + 1}", "http-server"]

  metadata = {
    ssh-keys = "${var.username}:${file("./ssh/terraform.pub")}"
  }

  # depends_on = [
  #   google_storage_bucket.bucket-x
  # ]

  metadata_startup_script = "${file("./script.sh")}"

  # connection {
  #   type = "ssh"
  #   user = var.username
  #   private_key = file("../ssh/terraform")
  #   host = self.network_interface[0].access_config[0].nat_ip
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt-get update",
  #     "sudo apt-get install -y nginx",
  #     "sudo service nginx start"
  #   ]
  # }
}
