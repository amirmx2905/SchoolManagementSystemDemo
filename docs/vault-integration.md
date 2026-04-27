# Vault Integration

## Secret Paths

| Path | Contents |
|------|----------|
| `secret/db` | RDS host, name, username, password |
| `secret/jwt` | JWT signing secret |
| `secret/smtp` | SMTP host, user, password |

## Initialization

```bash
export VAULT_ADDR='http://VAULT_PRIVATE_IP:8200'
vault operator init        # Save unseal keys and root token securely — NOT in repo
vault operator unseal      # Run 3 times with 3 different unseal keys
vault login ROOT_TOKEN

vault secrets enable -path=secret kv-v2

vault kv put secret/db host=RDS_ENDPOINT name=schooldb username=schooladmin password=CHANGEME
vault kv put secret/jwt secret=CHANGEME
vault kv put secret/smtp host=smtp.example.com user=user@example.com password=CHANGEME
```

## Auth Method (AppRole)

```bash
vault auth enable approle
vault policy write app-policy - <<EOF
path "secret/data/db"   { capabilities = ["read"] }
path "secret/data/jwt"  { capabilities = ["read"] }
path "secret/data/smtp" { capabilities = ["read"] }
EOF
vault write auth/approle/role/app-role token_policies="app-policy"
```

## Ansible Integration Example

```yaml
- name: Read DB secret from Vault
  set_fact:
    db_password: "{{ lookup('community.hashi_vault.vault_kv2_get', 'db', engine_mount_point='secret')['secret']['password'] }}"
  environment:
    VAULT_ADDR: "http://{{ vault_ip }}:8200"
    VAULT_TOKEN: "{{ vault_token }}"
```
