packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "my-ami" {
  region        = "eu-north-1"
  source_ami    = "ami-08eb150f611ca277f"
  instance_type = "t3.micro"
  ssh_username   = "ubuntu"
  ami_name       = "custom-ami-{{timestamp}}"
}

build {
  sources = ["source.amazon-ebs.my-ami"]

  provisioner "ansible" {
    playbook_file = "./playbook.yml"
  }
}
