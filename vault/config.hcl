storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1  # Enable TLS in production with tls_cert_file/tls_key_file
}

api_addr     = "http://REPLACE_WITH_VAULT_PRIVATE_IP:8200"
cluster_addr = "http://REPLACE_WITH_VAULT_PRIVATE_IP:8201"

ui = false
