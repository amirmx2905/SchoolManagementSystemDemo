# Verification Checklist

Use this checklist to validate the end-to-end deployment for submission.

## Infrastructure (Terraform)

- [ ] `terraform apply` completed without errors.
- [ ] VPC created in us-east-1.
- [ ] 2 public subnets and 2 private subnets created.
- [ ] App EC2 instances are running (2 instances).
- [ ] Vault EC2 instance is running (private subnet).
- [ ] RDS PostgreSQL instance is available.
- [ ] S3 bucket is created.

## Network and Security

- [ ] App ports 3000-3003 open on app security group.
- [ ] SSH to app EC2 restricted to developer IP.
- [ ] Vault API port 8200 allowed from EC2 security group.
- [ ] Vault SSH allowed from developer IP and app SG (jump host path).
- [ ] RDS port 5432 allowed only from EC2 security group.

## Ansible - App Servers

- [ ] `ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --limit app_servers` succeeds.
- [ ] Docker installed on app instances.
- [ ] Compose stack is deployed in `/opt/school-mgmt`.
- [ ] `docker ps` shows both placeholder services running.

## Ansible - Vault Server

- [ ] `ansible-playbook ansible/playbook.yml -i ansible/inventory.ini --limit vault_server` succeeds.
- [ ] Vault binary exists at `/usr/local/bin/vault`.
- [ ] Vault config exists at `/opt/vault/config.hcl`.
- [ ] `vault.service` is enabled and active.

## Vault Initialization and Secrets

- [ ] Vault initialized once with Shamir key shares.
- [ ] Vault unsealed with threshold number of keys.
- [ ] Root token saved securely outside repository.
- [ ] KV v2 enabled at path `secret`.
- [ ] Secrets written:
  - [ ] `secret/db`
  - [ ] `secret/jwt`
  - [ ] `secret/smtp`
- [ ] `vault kv get secret/db` works after login.

## Functional Checks

- [ ] SSH jump host path to Vault works.
- [ ] Vault status reports `Initialized: true` and `Sealed: false`.
- [ ] App hosts can run containers without permission issues.

## Submission Readiness

- [ ] README includes architecture, setup, and run instructions.
- [ ] `docs/infrastructure-design.md` and `docs/vault-integration.md` are up to date.
- [ ] This checklist is completed and attached/screenshotted for submission.
- [ ] No secrets committed in repository files.

## Optional Cost Cleanup

- [ ] When assignment demo is finished, run:

```bash
cd terraform
terraform destroy -auto-approve
```
