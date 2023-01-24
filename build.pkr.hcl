source "amazon-ebs" "ubuntu-lts" {
  region = "us-east-1"
  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
  instance_type  = "t2.small"
  ssh_username   = "ubuntu"
  ssh_agent_auth = false

  ami_name    = "hashicups_{{timestamp}}"
  ami_regions = ["us-east-1"]

  vpc_filter {
    filters = { 
      isDefault = "false"
      cidr = "10.65.0.0/16"
    }
  }
  subnet_filter {
    filters = {
        cidr = "10.65.0.0/24"
    }
  }
}

build {
  # HCP Packer settings
//   hcp_packer_registry {
//     bucket_name = "learn-packer-github-actions"
//     description = <<EOT
// This is an image for HashiCups.
//     EOT

//     bucket_labels = {
//       "hashicorp-learn" = "learn-packer-github-actions",
//     }
//   }

  sources = [
    "source.amazon-ebs.ubuntu-lts",
  ]

  # systemd unit for HashiCups service
  // provisioner "file" {
  //   source      = "hashicups.service"
  //   destination = "/tmp/hashicups.service"
  // }

  # Set up HashiCups
  provisioner "shell" {
    scripts = [
      "setup-deps-hashicups.sh"
    ]
  }

  // post-processor "manifest" {
  //   output     = "packer_manifest.json"
  //   strip_path = true
  //   custom_data = {
  //     iteration_id = packer.iterationID
  //   }
  // }
}
