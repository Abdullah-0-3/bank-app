resource "aws_key_pair" "bank-app-keys" {
  key_name   = var.key_name
  public_key = file("${path.module}/keys/bank-app.pub")
  tags       = var.tags
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "bank-app" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.bank-app-keys.key_name
  security_groups = [var.security_group_name]
  tags            = var.tags

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 25
    delete_on_termination = true
  }

  provisioner "file" {
    source      = "${path.module}/script/bootstrap.sh"
    destination = "/home/ubuntu/bootstrap.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/keys/bank-app.pvt")
      host        = self.public_ip
    }
  }

}