output "image_revocation_date" {
  value = data.hcp_packer_image.ubuntu_ap_southeast_1.revoke_at
}