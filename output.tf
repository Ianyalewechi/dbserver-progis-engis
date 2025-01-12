output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.progress_db.public_ip
}

output "key_pair_private_key" {
  description = "Private key content of the key pair"
  value       = tls_private_key.progis_key.private_key_pem
    sensitive = true
}
