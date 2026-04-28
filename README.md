# SchoolManagementSystemDemo

DevOps-focused college project that provisions and configures a school management demo platform on AWS using Terraform, Ansible, Docker, and HashiCorp Vault.

## Project Scope

- Infrastructure as code with Terraform (VPC, EC2, RDS, S3, security groups)
- Configuration management with Ansible
- Container runtime on app EC2 instances with Docker Compose
- Secret management with Vault on a private EC2 instance
- Cost-aware design for AWS Free Tier usage (where possible)

## Architecture Summary

- Region: us-east-1
- VPC CIDR: 10.0.0.0/16
- Public subnets: app EC2 instances
- Private subnets: Vault and RDS
- EC2: 2 app instances (t3.micro), 1 Vault instance (t3.micro)
- RDS: PostgreSQL 15 (db.t3.micro)
- S3: course files / assignments storage

High-level flow:

1. Terraform creates core infrastructure.
2. Ansible configures app servers and Vault server.
3. Vault is initialized and unsealed manually once.
4. Secrets are stored in Vault at `secret/db`, `secret/jwt`, `secret/smtp`.

## Repository Layout

- `terraform/`: AWS infrastructure modules and root configuration
- `ansible/`: inventory, playbook, and roles
- `vault/`: Vault runtime configuration (`config.hcl`)
- `docs/`: design and integration documentation

## Prerequisites

- macOS/Linux shell environment
- AWS account and IAM credentials configured locally
- Terraform >= 1.5
- Ansible >= 2.20
- SSH key pair available and imported in AWS EC2 key pairs

## Deployment Steps

### 1. Provision infrastructure

From `terraform/`:

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

After apply, collect:

- App EC2 public IPs
- Vault EC2 private IP
- RDS endpoint

### 2. Update Ansible inventory and vars

Set host values in `ansible/inventory.ini`.

- App hosts use public IPs.
- Vault host uses private IP and SSH ProxyCommand through app1.

Set application placeholders in `ansible/group_vars/app_servers.yml`.

### 3. Configure servers with Ansible

From repo root:

```bash
ansible-playbook ansible/playbook.yml -i ansible/inventory.ini
```

Expected outcomes:

- App servers: Docker + placeholder compose services running
- Vault server: Vault binary installed, config deployed, systemd service running

### 4. Initialize and unseal Vault (one-time)

SSH to Vault (through jump host), then:

```bash
export VAULT_ADDR=http://127.0.0.1:8200
vault operator init -key-shares=5 -key-threshold=3
vault operator unseal <key1>
vault operator unseal <key2>
vault operator unseal <key3>
vault login <root-token>
```

Important:

- Store unseal keys and root token outside the repository.
- Never commit secrets to git.

### 5. Enable KV and store secrets

```bash
vault secrets enable -path=secret kv-v2
vault kv put secret/db host=<rds-endpoint> name=schooldb username=schooladmin password=<db-password>
vault kv put secret/jwt secret=<jwt-secret>
vault kv put secret/smtp host=smtp.example.com user=notify@example.com password=<smtp-password>
```

## Verification

- App services up on app instances:
  - auth-service on port 3000
  - notifications-service on port 3003
- Vault service:

```bash
sudo systemctl is-active vault
```

- Vault health:

```bash
export VAULT_ADDR=http://127.0.0.1:8200
vault status
```

- Secret read test:

```bash
vault kv get secret/db
```

See `docs/verification-checklist.md` for a full step-by-step checklist.

## Cost and Free Tier Notes

- Project intentionally avoids ALB to reduce monthly costs.
- Current setup uses multiple t3.micro instances plus RDS; monitor billing regularly.
- Destroy resources when finished.

## Cleanup (Phase 8)

Phase 8 is intentionally on hold in this workspace/session. When ready:

```bash
cd terraform
terraform destroy -auto-approve
```

## Learning Notes

- Private subnet instances without NAT cannot install packages from the internet.
- Vault on small lab instances often needs `disable_mlock = true` in config.
- Jump-host SSH with explicit ProxyCommand is reliable for private EC2 management.
