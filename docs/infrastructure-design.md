# Infrastructure Design

## Resource Table

| Resource  | Type        | Size              | Purpose                              | Rationale                                                      |
| --------- | ----------- | ----------------- | ------------------------------------ | -------------------------------------------------------------- |
| EC2 App 1 | t3.small    | 2 vCPU / 2 GB     | auth-service + notifications-service | Enough RAM for 2 lightweight Docker containers                 |
| EC2 App 2 | t3.small    | 2 vCPU / 2 GB     | students-service + courses-service   | Same sizing for consistency                                    |
| EC2 Vault | t3.small    | 2 vCPU / 2 GB     | HashiCorp Vault server               | Isolated instance — no shared resources with app               |
| RDS       | db.t3.micro | 20 GB / single-AZ | PostgreSQL 15 database               | Free Tier eligible; single-AZ acceptable for a college project |
| S3        | Standard    | Pay per use       | Course files and assignments         | Versioning + SSE-S3 encryption enabled                         |
| ALB       | Application | —                 | Public traffic distribution          | Distributes load across both app EC2s                          |

## Network Design

- **VPC CIDR:** `10.0.0.0/16` — large enough for future expansion
- **Region:** `us-east-1`
- **Public subnets** (ALB lives here):
  - `10.0.1.0/24` — us-east-1a
  - `10.0.2.0/24` — us-east-1b
- **Private subnets** (EC2 apps, RDS, Vault — no internet exposure):
  - `10.0.3.0/24` — us-east-1a
  - `10.0.4.0/24` — us-east-1b

## Security Groups

| SG       | Port(s)   | Source    | Rationale                                       |
| -------- | --------- | --------- | ----------------------------------------------- |
| SG-ALB   | 80, 443   | 0.0.0.0/0 | Public internet access                          |
| SG-EC2   | 3000–3003 | SG-ALB    | App ports only reachable from the load balancer |
| SG-EC2   | 22        | My IP/32  | SSH restricted to developer machine only        |
| SG-RDS   | 5432      | SG-EC2    | DB only reachable from app instances            |
| SG-Vault | 8200      | SG-EC2    | Vault API only reachable from app instances     |
| SG-Vault | 22        | My IP/32  | SSH for admin access only                       |

## Architecture Flow

```
Internet
    │
    ▼
[ALB] — public subnets (us-east-1a / us-east-1b)
    │
    ├──► EC2 App1 — auth-service (3000) + notifications-service (3003)
    └──► EC2 App2 — students-service (3001) + courses-service (3002)
              │
              ├──► RDS PostgreSQL — private subnet, port 5432
              ├──► S3 Bucket — via IAM role, no public access
              └──► Vault EC2 — private subnet, port 8200
```

## Cost Control Notes

- All EC2 and RDS types are Free Tier eligible for the first 12 months
- Run `terraform destroy` at the end of each session to avoid charges
- S3 costs are minimal for a college project (< 1 GB expected)
- Enable AWS Budget alerts before running `terraform apply`

## Risks and Mitigations

| Risk                                            | Mitigation                                                      |
| ----------------------------------------------- | --------------------------------------------------------------- |
| AWS charges from forgetting to destroy          | Set budget alarm; always run `terraform destroy` after testing  |
| VPC/networking complexity                       | Use explicit CIDR planning above; modules handle routing tables |
| RDS in private subnet unreachable for debugging | Use EC2 App instance as a bastion jump host                     |
| Vault unsealing after reboot                    | Store unseal keys securely offline — never in the repo          |
