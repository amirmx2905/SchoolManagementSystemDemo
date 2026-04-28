storage "file" {
  path = "/opt/vault/data"
}

disable_mlock = true

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1  # Enable TLS in production with tls_cert_file/tls_key_file
}

api_addr     = "http://10.0.3.114:8200"
cluster_addr = "http://10.0.3.114:8201"

ui = false
