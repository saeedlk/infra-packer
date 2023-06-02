packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

data "hcp-packer-iteration" "ubuntu" {
  bucket_name = "learn-packer-ubuntu"
  channel     = "production"
}

data "hcp-packer-image" "ubuntu-ap" {
  bucket_name    = "learn-packer-ubuntu"
  iteration_id   = data.hcp-packer-iteration.ubuntu.id
  cloud_provider = "aws"
  region         = "ap-southeast-1"
}


source "amazon-ebs" "application-ap" {
  ami_name = "packer_AWS_{{timestamp}}_v${var.version}"

  region         = "ap-southeast-1"
  source_ami     = data.hcp-packer-image.ubuntu-ap.id
  instance_type  = "t2.micro"
  ssh_username   = "ubuntu"
  ssh_agent_auth = false

  tags = {
    Name = "learn-packer-application"
  }
}


build {
  hcp_packer_registry {
    bucket_name = "learn-packer-application"
    
    bucket_labels = {
      "foo-version" = "3.4.0",
      "foo"         = "bar",
    }
  }
  sources = [
    "source.amazon-ebs.application-ap"
  ]
}