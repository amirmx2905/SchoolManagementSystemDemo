# Infrastructure Design

## Resource Table

| Resource  | Type        | Size          | Purpose                              |
| --------- | ----------- | ------------- | ------------------------------------ |
| EC2 App 1 | t3.small    | 2 vCPU / 2 GB | auth-service + notifications-service |
| EC2 App 2 | t3.small    | 2 vCPU / 2 GB | students-service + courses-service   |
| EC2 Vault | t3.small    | 2 vCPU / 2 GB | HashiCorp Vault server               |
| RDS       | db.t3.micro | 20 GB         | PostgreSQL 15 database               |
| S3        | —           | —             | Course files and assignments         |
| ALB       | Application | —             | Public traffic distribution          |

## Network

- VPC: `10.0.0.0/16`
- Public subnets: `10.0.1.0/24` (us-east-1a), `10.0.2.0/24` (us-east-1b) — ALB
- Private subnets: `10.0.3.0/24` (us-east-1a), `10.0.4.0/24` (us-east-1b) — EC2, RDS, Vault

## Security Groups

| SG       | Allows    | From      |
| -------- | --------- | --------- |
| SG-ALB   | 80, 443   | 0.0.0.0/0 |
| SG-EC2   | 3000-3003 | SG-ALB    |
| SG-EC2   | 22        | My IP     |
| SG-RDS   | 5432      | SG-EC2    |
| SG-Vault | 8200      | SG-EC2    |
| SG-Vault | 22        | My IP     |

## Architecture Flow

```
Internet → ALB (public subnet)
         → EC2 App1 (auth + notifications)
         → EC2 App2 (students + courses)
              → RDS PostgreSQL (private subnet)
              → S3 Bucket
              → Vault EC2 (private subnet)
```
